--load values and resources
function love.load()
timer=0
tickAt=3
end

--draw onto the screen
function love.draw()
  
  
end

--update on every frame
function love.update(dt)
  timer=timer+dt
  if timer>3 then
    
    timer=0
  end
end

