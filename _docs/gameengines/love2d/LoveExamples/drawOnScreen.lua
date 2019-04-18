--load values and resources
function love.load()
  x=20
end

--draw onto the screen
function love.draw()
  love.graphics.setBackgroundColor(123,222,111,255);
  
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
    -- rotate around the center of the screen by angle radians
  love.graphics.translate(width/2, height/2)
  love.graphics.rotate(10)
  love.graphics.translate(-width/2, -height/2)
  
  --draw the drawing color
  love.graphics.setColor(255,111,111,255)
  --draw a point
  for i=0,100 do
    love.graphics.point(i,20*x)
  end
  --draw a line
  love.graphics.setColor(155,111,211,255)
  love.graphics.line(x,10,100,100,200,10,300,320,100,200,x,10)
  --draw a bezie curve
  
  --draw a rectngle
  love .graphics.rectangle("fill",200,200,40,120)
  --draw an arc
  love.graphics.setColor(244,233,122,255)
  love.graphics.arc("fill",100,100,40,0,math.pi/2)
  --draw a circle
  love.graphics.setColor(0,0,255,255)
  love.graphics.circle("fill",150,300,60,10)
  
  --draw a polygon
  --love.graphics.rotate(4)
  love.graphics.setColor(255,0,0,255)
  love.graphics.polygon("fill",100,100,150,200,50,300,100,100)
end

--update on every frame
function love.update(dt)
--x=x+1
end
