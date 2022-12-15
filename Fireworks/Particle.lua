require 'class'
local Vector=require 'Vector'
local lg=love.graphics

local M=class(function(self, x, y, R, G, B, v)
  self.dead=false
  self.Position=Vector(x, y)
  self.Velocity=Vector(math.random(10,50),0):rotate(math.random(0, 360))
  self.elapsed=0
  self.livetime=math.random(20,50)/10
  self.R=R or math.random(50, 255)/255
  self.G=G or math.random(50, 255)/255
  self.B=B or math.random(50, 255)/255
  self.variable=v or 'R'
  self[self.variable]=math.random(50, 255)/255
end)

function M:update(dt)
  self.elapsed=self.elapsed+dt
  self.Position=self.Position+self.Velocity*dt
  self.Velocity=self.Velocity+Vector(0,50)*dt
  if self.elapsed>=self.livetime then
    self.dead=true
  end
end

function M:isDead()
  return self.dead
end

function M:draw()
  local alpha=math.ceil(255-255*(self.elapsed/self.livetime))/255
  if alpha<0 then alpha=0 end
  lg.setColor(self.R, self.G, self.B, alpha)
  lg.circle('fill', self.Position.x, self.Position.y, 2, 7)
end
return M

