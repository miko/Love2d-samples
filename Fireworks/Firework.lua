require 'class'
local Vector=require 'Vector'
local Particle=require 'Particle'
STATE={ROCKET=1, EXPLODE=2, LIVE=3, DEAD=4}

local M=class(function(self, x, y)
  self.Position=Vector(x, y)
  self.state=STATE.ROCKET
  self.Particles={}
  self.numParticles=math.random(150, 450)
  self.elapsed=0
  self.R=math.random(50, 255)
  self.G=math.random(50, 255)
  self.B=math.random(50, 255)
  self.StartPosition=Vector(math.random(0, love.graphics.getWidth()), love.graphics.getHeight())
  self.elapsed=0
  self.livetime=math.random(3,20)/10
end)

function M:update(dt)
  self.elapsed=self.elapsed+dt
  local state=self.state
  if state==STATE.LIVE or state==STATE.EXPLODE then
    if state==STATE.EXPLODE then
      for i=1,math.random(50,120) do
        self:addParticle(self.Position.x, self.Position.y)
      end
      if #self.Particles>= self.numParticles then
        self.state=STATE.LIVE
      end
    end

    for k=#self.Particles,1,-1 do
     local p=self.Particles[k]
     if p:isDead() then
       table.remove(self.Particles, k) 
     else
       p:update(dt)
     end
    end
    if state==STATE.LIVE and #self.Particles==0 then
      self.state=STATE.DEAD
    end
  elseif state==STATE.DEAD then
    return
  elseif state==STATE.ROCKET then
    local pct=self.elapsed/self.livetime*100
    if pct>=100 then
      self.elapsed=0
      self.state=STATE.EXPLODE
    end
  else
    error('UNKNOWN STATE: '..state)
  end
end

function M:draw()
  if self.state==STATE.ROCKET then
    local pct=self.elapsed/self.livetime
    local d=(self.StartPosition-self.Position)*pct
    local d2=(self.StartPosition-self.Position)*(pct+0.03)
    local pos1=self.StartPosition-d
    local pos2=self.StartPosition-d2
    
    love.graphics.setColor(self.R, self.G, self.B, 255)
    love.graphics.setLineWidth(3)
    love.graphics.line(pos1.x, pos1.y, pos2.x, pos2.y)
    love.graphics.circle('fill', self.StartPosition.x, self.StartPosition.y, 10, 10)
  else
    for k,v in ipairs(self.Particles) do
      v:draw()
    end
  end
end

function M:isDead()
  return self.state==STATE.DEAD
end

function M:addParticle(x, y)
  table.insert(self.Particles, Particle(x, y, self.R, self.G, self.B))
end

return M
