local Char=require('Char')
local lg=love.graphics

local M=class(Char, function(self, W, H)
  Char.init(self, 'B', W, H)
  self.color={0, 255,0,255}
  local P={}
  local p=5
  for i=-90, 90, p do
    P[#P+1]=W*math.cos(math.rad(i))
    P[#P+1]=H*0.3*math.sin(math.rad(i))
  end
  self.POINTS=P
end)

function M:_draw()
  lg.setColor(self.color)
  lg.translate(-self.W/2, -self.H/5)
  lg.polygon('fill', self.POINTS)
  lg.translate(0, 2*self.H/5)
  lg.polygon('fill', self.POINTS)
  lg.translate(self.W/2, -self.H/5)
  lg.setColor(0, 0, 0, 255)
  lg.circle('fill', 0.6*self.W/2, -0.6*self.H/3, self.H/15)
  lg.circle('fill', 0.6*self.W/2, 0.6*self.H/3, self.H/15)
end

return M
