-- load ttf file font. set 20px font-size
mainFont = love.graphics.newFont("assets/unbom.ttf", 35);
text="This is Love"


function love.draw()
    -- set font before draw text
    love.graphics.setBackgroundColor(233,211,123,255)
    love.graphics.setColor(223,111,234,255)
    love.graphics.setFont(mainFont);
    -- draw text "Hello world!" at left: 100, top: 200
    love.graphics.print(text, 200, 200);
end;