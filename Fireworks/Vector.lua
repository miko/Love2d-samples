require 'class'

local M=class(function(self, x, y)
  self.x=x or 0
  self.y=y or 0
end)

function M:isVector()
  return getmetatable(self)==M
end

function M:__add(v)
  return M(self.x+v.x, self.y+v.y)
end

function M:__sub(v)
  return M(self.x-v.x, self.y-v.y)
end

function M:__mul(m)
  if type(self)=='number' and M.isVector(m) then
    self, m=m, self
  end
  if type(m)=='number' then
    return M(self.x*m, self.y*m)
  else
    return self.x*m.x+self.y*m.y
  end
end

function M:len()
  return (self*self)^0.5
end

function M:rotate(phi)
  phi=math.rad(phi)
  local c, s = math.cos(phi), math.sin(phi)
  self.x, self.y = c * self.x - s * self.y, s * self.x + c * self.y
  return self
end


function M:__tostring()
  return string.format('<%s,%s>', self.x, self.y)
end

return M
