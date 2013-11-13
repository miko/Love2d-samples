local M={}
local MT={}
MT.__index=M

function M.new(P)
  local o=setmetatable({}, MT)
  o:initialize(P)
  return o
end

function M:getName()
  return 'Key'
end

function M:initialize(P)
  self.taken=false
  self.x=100+math.random(500)
  self.y=250
end

function M:takeAction(P)
  if not self.taken then
    self.taken=true
    return true, 'Key taken'
  else
    return true, 'Key already taken!'
  end
end

function M:dropAction(P)
  if self.taken then
    self.taken=false
    return true, 'Key dropped'
  else
    return true, 'Key already dropped!'
  end
end

function M:draw()
  love.graphics.setColor(0, 0, 0)
  local x, y
  if self.taken then
    x, y=20, 20
  else
    x, y=self.x, self.y
  end
  love.graphics.rectangle('fill', x+10, y, 50, 20)
  love.graphics.circle('fill', x, y+10, 20)
end

return M
