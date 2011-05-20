local SpriteSheet=require 'SpriteSheet'

function love.load()
  local img='spritesheet.png'
  framewidth=32
  frameheight=32
  S=SpriteSheet.new(img, framewidth, frameheight)
  selected=0
  Animations={}
  for row=1,5 do
    local a=S:createAnimation()
    for col=1,4 do
      a:addFrame(col, row)
    end
    Animations[#Animations+1]=a
  end
  a=S:createAnimation()
  for row=1,5 do
    for col=1,4 do
      a:addFrame(col, row)
    end
  end
  Animations[#Animations+1]=a
end

function love.update(dt)
  for k,v in ipairs(Animations) do v:update(dt) end
end

function love.draw()
  for k,v in ipairs(Animations) do
    v:draw(k*framewidth, 0)
    if k==selected then
      love.graphics.setColor(255,0,0,127)
      love.graphics.rectangle('fill', k*framewidth,0, framewidth, frameheight)
      love.graphics.setColor(255,255, 255,255)
    end
  end
  local a=Animations[selected]
  if a then
    love.graphics.print(string.format("Animation: %d Delay: %f", selected, a:getDelay()), 100, 100)
  end
    love.graphics.printf("Press 1.."..#Animations.." to select an animation. \r\nWhen selected, press SPACE to toggle playing, and RIGHT/LEFT to increase/decrease the delay between frames.", 0, 150, 800)
    
end

function love.keypressed(k)
  if k=='q' or k=='escape' then
    love.event.push('q')
  end
  local n=tonumber(k)
  local a=Animations[n]
  if a then
    selected=n
  else
    a=Animations[selected]
    if a then
      if k==" " then
        if a:isPaused() then
          a:play()
        else
          a:pause()
        end    
      elseif k=="right" then
        a:setDelay(a:getDelay()-0.01)    
      elseif k=="left" then
        a:setDelay(a:getDelay()+0.01)
      else
        selected=0
      end
    else
      selected=0
    end    
  end
end
