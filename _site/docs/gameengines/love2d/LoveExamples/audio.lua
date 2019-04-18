src1 = love.audio.newSource("bang.wav", "static")//static tells to store into ram
src2 = love.audio.newSource("bgm.mp3")

src1:setVolume(0.9) -- 90% of ordinary volume
src1:setPitch(0.5) -- one octave lower
src2:setVolume(0.7)

src1:play()
src2:play()