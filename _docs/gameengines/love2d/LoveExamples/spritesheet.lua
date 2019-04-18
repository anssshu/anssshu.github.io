local quadInfo = {
  {  0,  0 }, -- 1 = grass 
  { 32,  0 }, -- 2 = box
  {  0, 32 }, -- 3 = flowers
  { 32, 32 }  -- 4 = boxTop
}


Quads = {}
for i,info in ipairs(quadInfo) do
  -- info[1] = x, info[2] = y
  Quads[i] = love.graphics.newQuad(info[1], info[2], TileW, TileH, tilesetW, tilesetH)
end