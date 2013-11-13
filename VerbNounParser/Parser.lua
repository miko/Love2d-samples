local P={}
local MT={}
MT.__index=P

function P.new(...)
  local o=setmetatable({}, MT)
  o:initialize(...)
  return o
end

function P:registerObject(o)
  table.insert(self.Objects, o)
end

function P:findObjects(name)
  local o={}
  for k,v in ipairs(self.Objects) do
    if name:lower()==v:getName():lower() then
      o[#o+1]=v
    end
  end
  return o
end

function P:initialize(...)
  self.Objects={}
end

function P:parse(buf)
  -- tokenize
  local tokens={}
  for token in buf:gmatch('%w+') do
    table.insert(tokens, token:lower())
  end
  -- find object
  local objects
  for k,v in ipairs(tokens) do
    local o=self:findObjects(v)
    if #o>0 then
      objects=o
      table.remove(tokens, k)
      break
    end
  end
  if not objects then
    return nil, 'No objects found'
  end
  -- find action
  local object=objects[1] -- assuming all objects found have the same methods
  for k,v in ipairs(tokens) do
    local method=v..'Action'
    if type(object[method])=='function' then
      table.remove(tokens, k)
      local res={}
      for a,b in ipairs(objects) do
        local st,re=b[method](b, tokens)
        if st then
          res[#res+1]=re
        end
      end
      return true, res
    end
  end
  return nil, 'Unknown action for this object '..object:getName()
end

function P:getObjects()
  return self.Objects
end

return P


