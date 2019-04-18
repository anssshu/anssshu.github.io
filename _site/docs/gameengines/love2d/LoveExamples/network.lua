--------the client script-------------------
local socket = require "socket"

-- the address and port of the server
local address, port = "localhost", 12345

local entity -- entity is what we'll be controlling
local updaterate = 0.1 -- how long to wait, in seconds, before requesting an update

local world = {} -- the empty world-statelocal t

function love.load()
    udp = socket.udp()
    udp:settimeout(0)
    udp:setpeername(address, port)
    math.randomseed(os.time())
    entity = tostring(math.random(99999))
    local dg = string.format("%s %s %d %d", entity, 'at', 320, 240)
    udp:send(dg) -- the magic line in question.
   
    -- t is just a variable we use to help us with the update rate in love.update.
    t = 0 -- (re)set t to 0
end

function love.update(deltatime)
    t = t + deltatime -- increase t by the deltatime
   
    if t > updaterate then
        local x, y = 0, 0
        if love.keyboard.isDown('up') then  y=y-(20*t) end
        if love.keyboard.isDown('down') then    y=y+(20*t) end
        if love.keyboard.isDown('left') then    x=x-(20*t) end
        if love.keyboard.isDown('right') then   x=x+(20*t) end
        local dg = string.format("%s %s %f %f", entity, 'move', x, y)
        udp:send(dg)
        local dg = string.format("%s %s $", entity, 'update')
        udp:send(dg)

        t=t-updaterate -- set t for the next round
    end
    
    repeat
        data, msg = udp:receive()

        if data then -- you remember, right? that all values in lua evaluate as true, save nil and false?
          ent, cmd, parms = data:match("^(%S*) (%S*) (.*)")
            if cmd == 'at' then
                local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
                assert(x and y)
                x, y = tonumber(x), tonumber(y)
                world[ent] = {x=x, y=y}
                else
                print("unrecognised command:", cmd)
            end
            elseif msg ~= 'timeout' then
            error("Network error: "..tostring(msg))
        end
    until not data
end

function love.draw()
    -- pretty simple, we
    for k, v in pairs(world) do
        love.graphics.print(k, v.x, v.y)
    end
end

-------the server----script----------------

local socket = require "socket"
local udp = socket.udp()
udp:settimeout(0)
udp:setsockname('*', 12345)
local world = {} -- the empty world-state
local data, msg_or_ip, port_or_nil
local entity, cmd, parms
local running = true

print "Beginning server loop."
while running do
  data, msg_or_ip, port_or_nil = udp:receivefrom()
    if data then
        -- more of these funky match paterns!
        entity, cmd, parms = data:match("^(%S*) (%S*) (.*)")
         if cmd == 'move' then
            local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
            assert(x and y) -- validation is better, but asserts will serve.
            -- don't forget, even if you matched a "number", the result is still a string!
            -- thankfully conversion is easy in lua.
            x, y = tonumber(x), tonumber(y)
            -- and finally we stash it away
            local ent = world[entity] or {x=0, y=0}
            world[entity] = {x=ent.x+x, y=ent.y+y}
        elseif cmd == 'at' then
            local x, y = parms:match("^(%-?[%d.e]*) (%-?[%d.e]*)$")
            assert(x and y) -- validation is better, but asserts will serve.
            x, y = tonumber(x), tonumber(y)
            world[entity] = {x=x, y=y}
        elseif cmd == 'update' then
            for k, v in pairs(world) do
                udp:sendto(string.format("%s %s %d %d", k, 'at', v.x, v.y), msg_or_ip,  port_or_nil)
            end
        elseif cmd == 'quit' then
            running = false;
            else
            print("unrecognised command:", cmd)
        end
    elseif msg_or_ip ~= 'timeout' then
        error("Unknown network error: "..tostring(msg))
    end
   
    socket.sleep(0.01)
end

print "Thank you."