local Intro=require 'Intro'
function love.load()
  I=Intro()
  local t1=I:addText('LoveJam Test Jam entry!'):setPosition(20, 50):setColor(0, 255, 0):setFont(60):center()
  local t2=I:addText('Made with Love2d'):setPosition(400, 200):setColor(0, 0, 255):setFont(30)
  I:addText('(C) 2011 miko - average Love user'):setPosition(10, 500):setColor(255,0,0):setFont(40):center()
  I:addImage('face-grin.png'):setPosition(300, 300)

  I:addAudio('zero-project - 01 - Celtic dream.ogg')
  I:setDuration(5.5)
  I:setDelay(2.5)
  I:setBlinks(2, t1, t2)
  I:start()
end

function love.update(dt)
  love.event.push('q')
end
--[[
function love.keypressed(a, b)
  love.event.push('q')
end
--]]
