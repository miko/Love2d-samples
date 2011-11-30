local Char=require('Char')
local lg=love.graphics

local M=class(Char, function(self, W, H)
  Char.init(self, 'O', W, H)
  self.color={255,255,0,255}
  self.dx=1.1*self.W/2*math.cos(math.rad(45))
  self.dy=-1.1*self.H/2*math.sin(math.rad(45))
end)

function M:_draw()
  lg.setColor(self.color)
  lg.circle('fill', 0, 0, self.W/2, self.W/2 )
  lg.circle('fill', self.dx, self.dy, 0.1*self.W, self.W/2 )
  lg.circle('fill', -self.dx, self.dy, 0.1*self.W, self.W/2 )
end

return M
