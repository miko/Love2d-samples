local Parser=require 'Parser'
local Door=require 'Door'
local Window=require 'Window'
local Key=require 'Key'
local Console=require 'Console'

local Objects
function love.load()
  love.graphics.setBackgroundColor(255, 255, 255)
  P=Parser.new()

  local blackdoor=Door.new({color='black'})
  local greendoor=Door.new({color='green'})
  local reddoor=Door.new({color='red'})

  local window=Window.new()
  console=Console.new()
  local key=Key.new()

  P:registerObject(greendoor)
  P:registerObject(reddoor)
  P:registerObject(blackdoor)
  P:registerObject(window)
  P:registerObject(key)
  console:setCallback(function(buf)
    if buf=='exit' or buf=='quit' then
      love.event.quit()
    end
    local st, res=P:parse(buf)
    if st then
      console:addLine(res)
    else
      console:addLine('Error: '.. res)
    end
  end)
end

function love.draw()
  for k,v in ipairs(P:getObjects()) do
    v:draw()
  end
  console:draw()
end

function love.update(dt)
  console:update(dt)
end

function love.keypressed(k, u)
  console:keyPressed(k, u)
end

