local lg=love.graphics

local Animation={}
Animation.__index=Animation

function Animation.new(spritesheet)
  local obj={parent=spritesheet, name=name, frames={}, currentFrame=0, delay=0.1, playing=true, elapsed=0}
  return setmetatable(obj, Animation)
end

function Animation:draw(x, y)
  local quad=self.frames[self.currentFrame]
  if quad then
    lg.draw(self.parent.img, quad, x, y)
  end
end

function Animation:update(dt)
  if #self.frames==0 or not self.playing then return end
  self.elapsed=self.elapsed+dt
  if self.elapsed>=self.delay then
    self.elapsed=self.elapsed-self.delay
    self.currentFrame=self.currentFrame+1
    if self.currentFrame>#self.frames then
      self.currentFrame=1
    end
  end
end

function Animation:addFrame(col, row)
  local parent=self.parent
  local w,h=parent.w, parent.h
  local quad=lg.newQuad((col-1)*w, (row-1)*h, w, h, parent.imgw, parent.imgh)
  self.frames[#self.frames+1]=quad
  return self
end

function Animation:play()
  self.playing=true
end

function Animation:stop()
  self.playing=false
  self.currentFrame=1
  self.elapsed=0
end

function Animation:pause()
  self.playing=false
end

function Animation:setDelay(s)
  self.delay=s
  return self
end

function Animation:getDelay()
  return self.delay
end

function Animation:isPaused()
  return self.playing==false
end
  
local SpriteSheet={}
SpriteSheet.__index=SpriteSheet

function SpriteSheet.new(img, w, h)
  if type(img)=='string' then
    img=lg.newImage(img)
  end
  local obj={img=img, w=w, h=h, Animations={}}
  obj.imgw=img:getWidth()
  obj.imgh=img:getHeight()
  return setmetatable(obj, SpriteSheet)
end

function SpriteSheet:createAnimation(...)
  local a=Animation.new(self)
  return a
end

return SpriteSheet
