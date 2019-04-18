-- load ttf file font. set 35px font-size
function love.load()
  img=love.graphics.newImage("assets/icon.png")
  angle=math.pi/10
  x=100
end



function love.draw()
    -- set font before draw text
    love.graphics.setBackgroundColor(233,211,123,255)
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    -- rotate around the center of the screen by angle radians
    love.graphics.push()
    love.graphics.translate(width/2, height/2)
    love.graphics.rotate(angle)
    
    love.graphics.draw(img,20,0);
    
   
    love.graphics.pop()
    
   
end;
function love.update(dt)
  
  love.timer.sleep(.01)
  angle = angle + dt * math.pi/2
  angle = angle % (2*math.pi)
 
  
  
end