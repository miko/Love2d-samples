local M={}
local MT={}
MT.__index=M

function M.new(P)
  local o=setmetatable({}, MT)
  o:initialize(P)
  return o
end

function M:getName()
  return 'Door'
end

function M:initialize(P)
  self.color=P.color or 'black'
  self.open=false
  self.x=100+math.random(500)
  self.y=250
  self.w=80
  self.h=100
end

function M:openAction(P)
  local found=false
  if #P>0 then
    -- find color
    for k,v in ipairs(P) do
      if v:lower()==self.color:lower() then
        found=true
        break
      end
    end
  else
    found=true
  end
  if found then
    if not self.open then
      self.open=true
      return true, 'Door '..self.color..' opened'
    else
      return true, 'Door '..self.color..' already open!'
    end
  else
    return nil, 'Not for me'
  end
end

function M:closeAction(P)
  local found=false
  if #P>0 then
    -- find color
    for k,v in ipairs(P) do
      if v:lower()==self.color:lower() then
        found=true
        break
      end
    end
  else
    found=true
  end
  if found then
    if self.open then
      self.open=false
      return true, 'Door '..self.color..' closed'
    else
      return true, 'Door '..self.color..' already closed!'
    end
  else
    return nil, 'Not for me'
  end
end

local Colors={red={255,0,0}, green={0,255,0}, black={0,0,0}}
function M:draw()
  if Colors[self.color] then
    love.graphics.setColor(Colors[self.color])
  end
  if self.open then
    love.graphics.rectangle('fill', self.x, self.y, self.w/4, self.h)
  else
    love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
  end
  
end

return M
