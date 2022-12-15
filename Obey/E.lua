local Char=require('Char')
local lg=love.graphics

local M=class(Char, function(self, W, H)
  Char.init(self, 'E', W, H)
  self.color={0, 0, 1, 1}
end)

function M:_draw()
  lg.setColor(self.color)
  local H2=self.H/2
  local W2=self.W/2
  local w=math.min(self.W/10, self.H/10)
  lg.setLineWidth(2*w)

  lg.line(-W2+w,-H2+w, W2,-H2+w)
  lg.line(-W2+w,0, W2,0)
  lg.line(-W2+w,H2-w, W2,H2-w)
  lg.line(-W2+w,-H2, -W2+w,H2)
end

return M
