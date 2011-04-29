local M={}
M.KONAMI={'up','up','down','down','left','right','left','right','b','a'}

local STATES={}
local CURRSTATE

local function setNextState(char, state)
  if not state then 
    state=STATES
  end
  if not state[char] then
    state[char]={}
  end
  return state[char]
end

local function getNextState(char, state)
  if not state then 
    state=STATES
  end
  return state[char]
end

function M.setCode(c, fn)
  if type(c)=='string' then
    local c2={}
    for char in c:gmatch('.') do c2[#c2+1]=char end
    c=c2
  end
  local st
  for k,v in ipairs(c) do
    st=setNextState(v, st)
  end
  st.done=fn
end

function M.keypressed(a)
  CURRSTATE=getNextState(a, CURRSTATE)
  if CURRSTATE then
    if CURRSTATE.done then
      CURRSTATE.done()
      CURRSTATE=nil
    else
      --tracking...
    end
  else
    -- start from beginning
    CURRSTATE=getNextState(a)
  end
end

return M

