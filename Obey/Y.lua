local Char=require('Char')
local lg=love.graphics

local M=class(Char, function(self, W, H)
  Char.init(self, 'Y', W, H)
  self.color={0,0,255, 255}
end)

function M:_draw()
  lg.setColor(self.color)
  local W2=self.W/2
  local H2=self.H/2
  local w=math.min(self.W/10, self.H/10)
  lg.setLineWidth(2*w)
  lg.line(-W2,-H2, 0,0, 0,H2, 0,0, W2,-H2)
end

return M
