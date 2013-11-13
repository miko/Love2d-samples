local M={}
local MT={}
MT.__index=M

function M.new(P)
  local o=setmetatable({}, MT)
  o:initialize(P)
  return o
end

function M:getName()
  return 'Window'
end

function M:initialize(P)
  self.open=false
  self.x=100+math.random(500)
  self.y=150
  self.w=50
  self.h=50
end

function M:openAction(P)
  if not self.open then
    self.open=true
    return true, 'Window opened'
  else
    return true, 'Window already open!'
  end
end

function M:closeAction(P)
  if self.open then
    self.open=false
    return true, 'Window closed'
  else
    return true, 'Window already closed!'
  end
end

function M:draw()
  love.graphics.setColor(0, 100, 255)
  if self.open then
    love.graphics.rectangle('fill', self.x, self.y, self.w/4, self.h)
  else
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
  end
  
end

return M
