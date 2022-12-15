local Intro=require 'Intro'
function love.load()
  I=Intro()
  local t1=I:addText('LoveJam Test Jam entry!'):setPosition(20, 50):setColor(0, 1, 0):setFont(60):center()
  local t2=I:addText('Made with Love2d'):setPosition(400, 200):setColor(0, 0, 1):setFont(30)
  local t3=I:addText('(C) 2011 miko - average Love user'):setPosition(10, 500):setColor(1,0,0):setFont(40):center()
  I:addImage('logo.png'):setPosition(200, 180)
  I:addImage('face-grin.png'):setPosition(400, 350)

  I:addAudio('zero-project - 01 - Celtic dream.ogg')
  I:setDuration(5)
  I:setDelay(5)
  I:setBlinks(2, t1, t2)
  I:start()
end

function love.update(dt)
  love.event.quit()
end
--[[
function love.keypressed(a, b)
  love.event.quit()
end
--]]
