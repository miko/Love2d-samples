if type(love._version)~='string' then
  error('love 0.8+ required!')
end

local lg=love.graphics
--W,H=512, 512
W,H=90,90

local O=require 'O'(W, H):setPosition(W/4, H/4):setScale(0.5)
local B=require 'B'(W, H):setPosition(3*W/4, H/4):setScale(0.5)
local E=require 'E'(W, H):setPosition(W/4, 3*H/4):setScale(0.5)
local Y=require 'Y'(W, H):setPosition(3*W/4, 3*H/4):setScale(0.5)

local time=3

if false then
  -- RECTANGLE
  O:setAnimation(time):move(W/4,0.9*-H/10):scale(2,0.6)
  B:setAnimation(time):rotate(-90):scale(0.4, 1.6):move(-W/4, -H/8)
  E:setAnimation(time):move(W/4,H/10):rotate(90):scale(1,2)
  Y:setAnimation(time):move(-W/4,-H/4):scale(2,0.8)
else --CIRCLE
  O:setAnimation(time):move(W/4,0.8*-H/10):scale(0.8, 0.7)
  B:setAnimation(time):rotate(-90):scale(0.4,0.7):move(-W/4, -H/8)
  E:setAnimation(time):move(W/4,H/10):rotate(90):scale(1)
  Y:setAnimation(time):move(-W/4,-H/4):scale(0.8)
end

function Y:onAnimationFinished()
  local scr=lg.captureScreenshot('miko.png')
end

function love.load()
  love.window.setMode(W, H, {resizable =true})
  Chars={O, B, E, Y}
end

function love.draw()
  for k,v in ipairs(Chars) do
    v:draw()
  end
end
function love.update(dt)
  for k,v in ipairs(Chars) do
    v:update(dt)
  end
end

