function love.load()
  val=0
   love.mouse.setVisible(false) -- make default mouse invisible
   img = love.graphics.newImage("icon.png") -- load in a custom mouse image
end
function love.draw()
   local x, y = love.mouse.getPosition() -- get the position of the mouse
   love.graphics.draw(img, val, y) -- draw the custom mouse image
end






val = 0   -- establish a variable for later use
function love.update(dt)
    if love.mouse.isDown("r") then
        val = val + 1  -- we will increase the variable by 1 for every second the button is held down
    end
end

