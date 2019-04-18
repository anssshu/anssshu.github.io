function love.load()
map = {
    { 1, 1, 1, 1 },
    { 1, 0, 0, 1 },
    { 1, 0, 1, 1 },
    { 1, 1, 1, 1 }
}
end



function love.draw()
    for y=1, #map do
        for x=1, #map[y] do
            if map[y][x] == 1 then
                love.graphics.rectangle("line", x * 32, y * 32, 32, 32)
            end
        end
    end
end