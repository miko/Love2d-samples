require 'class'
local lg=love.graphics

local M=class(function(self, name, W, H)
  self.W, self.H=W, H
  self.position={0,0}
  self.rotation=0
  self._scale={1,1}
  self.name=name or 'unnamed'
end)

function M:draw()
  lg.push()
  lg.translate(self.position[1], self.position[2])
  lg.rotate(math.rad(self.rotation))
  lg.scale(self._scale[1], self._scale[2])
  --predraw
  if self._draw then
    self:_draw()
  end
  --postdraw
  lg.pop()
end

function M:setPosition(x, y)
  self.position={x, y}
  return self
end
function M:setScale(sx, sy)
  self._scale={sx, sy or sx}
  return self
end
function M:setRotation(r)
  self.rotation=r
  return self
end

function M:rotate(dr)
  local newrotation=self.rotation+dr
  if self.animated then
    self._startRotation=self.rotation
    self._endRotation=newrotation
  else
    self.rotation=newrotation
  end
  return self
end

function M:move(dx, dy)
  local newposition={self.position[1]+dx, self.position[2]+dy}
  if self.animated then
    self._startPosition=self.position
    self._endPosition=newposition
  else
    self.position=newposition
  end
  return self
end
function M:scale(dsx, dsy)
  dsy=dsy or dsx
  local newscalex=self._scale[1]*dsx
  local newscaley=self._scale[2]*dsy
  if self.animated then
    self._startScale=self._scale
    self._endScale={newscalex, newscaley}
  else
    self._scale={newscalex, newscaley}
  end
  return self
end

function M:setAnimation(duration)
  if not duration then
    self.animated=nil
  else
    self.animated=true
    self.duration=duration
    self._startPosition=self.position
    self._endPosition=self.position
    self._startRotation=self.rotation
    self._endRotation=self.rotation
    self._startScale=self.scale
    self._endScale=self.scale
  end
  return self
end

function M:update(dt)
  if not self.animated then return end
  if not self._elapsed then
    self._elapsed=0
  else
    self._elapsed=self._elapsed+dt
  end
  if self._elapsed>=self.duration then
    self.animated=nil
    self._scale=self._endScale
    self.position=self._endPosition
    self.rotation=self._endRotation 
    self:onAnimationFinished()
  else
    local pct=self._elapsed/self.duration
    self.rotation=self._startRotation*(1-pct)+self._endRotation*pct
    self._scale={
      self._startScale[1]*(1-pct)+self._endScale[1]*pct,
      self._startScale[2]*(1-pct)+self._endScale[2]*pct
    }
    self.position={
      self._startPosition[1]*(1-pct)+self._endPosition[1]*pct,
      self._startPosition[2]*(1-pct)+self._endPosition[2]*pct
    }
  end
end

function M:onAnimationFinished()
end
return M
