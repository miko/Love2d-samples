local M={}
local MT={}
MT.__index=M

function M.new(P)
  local o=setmetatable({}, MT)
  o:initialize(P)
  return o
end

function M:getName()
  return 'Console'
end

function M:initialize(P)
  self.prompt='> '
  self.line=''
  self.data={}
  self.w=love.graphics.getWidth()
  self.h=200
  self.x=0
  self.y=love.graphics.getHeight()-self.h
  self.showCursor=false
  self.cursorTime=0
  self.callback=function(msg) print('Entered: '..msg); self:addLine(msg)  end
end

function M:setCallback(cb)
  self.callback=cb
end

function M:update(dt)
  self.cursorTime=self.cursorTime+dt
  if self.cursorTime>0.5 then
    self.cursorTime=self.cursorTime-0.5
    self.showCursor=not self.showCursor
  end
end

function M:draw()
  love.graphics.setScissor(self.x, self.y, self.w, self.h)
  love.graphics.setColor(1, 1,1, 0.5)
  love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
  love.graphics.setColor(0.2, 0.2, 0.2, 0.9)
  --love.graphics.setLineWidth(3)
  love.graphics.rectangle('line', self.x, self.y, self.w, self.h)

  for k=1, #self.data do
    love.graphics.print(self.data[k], self.x+5, self.y+self.h-40-(#self.data-k)*15)
  end

  local l=self.prompt..self.line
  if self.showCursor then l=l..'_' end
  love.graphics.print(l, self.x+5, self.y+self.h-20)
  love.graphics.setScissor()
end

function M:keyPressed(k)
  if k=='delete' or k=='backspace' then
    if #self.line>0 then
      self.line=self.line:sub(1, -2)
    end
  elseif k=='return' then
    if type(self.callback)=='function' then
      self.callback(self.line, self)
    end
    self.line=''
  end
end

function M:textInput(t)
  self.line=self.line..t
end

function M:addLine(l)
  if type(l)=='table' then
    for k,v in ipairs(l) do
      self:addLine(v)
    end
  else
    table.insert(self.data, l)
    if #self.data>8 then
      table.remove(self.data, 1)
    end
  end
end

return M

