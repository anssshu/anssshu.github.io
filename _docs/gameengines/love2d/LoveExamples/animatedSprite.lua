-- load ttf file font. set 35px font-size
function love.load()
  img=love.graphics.newImage("assets/sheet.png")
  
  s=love.audio.newSource("assets/music.mp3")
  
  frame={}
  frame[2]=love.graphics.newImage('assets/frame0.png')
  frame[1]=love.graphics.newImage('assets/frame1.png')
  frame[0]=love.graphics.newImage('assets/frame2.png')
  char=frame[0]
  timer=0
  num=0
end



function love.draw()
  
  love.graphics.setBackgroundColor(255,255,255,255)
  love.graphics.setColor(255,255,255,255)
  --draw the character
  
  love.graphics.draw(char,200,200)
  --draw the spritesheet char
   love.graphics.draw(img,q,100,100)
  --love.audio.play(s
  s:play()
  love.graphics.setColor(255,0,255,255)
  love.graphics.scale(3)
  love.graphics.print("press the w button to run",0,10)
  
end
function love.update(dt)
  q=love.graphics.newQuad(64*num,0,64,70,img:getDimensions())
  
   if (love.keyboard.isDown('w')) then
      timer=timer+dt*2
      char=frame[num]
      if (timer>0.2) then
        num=num+1
        timer=0
      end
      if (num>2) then
        num=0
      end
    end
    
end