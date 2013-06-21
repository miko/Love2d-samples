local lg=love.graphics
local Options={
  {name='play', title='Play the game!'},
  {name='help', title='Help'},
  {name='diagonal', title='Check diagonal positions?', options={'YES','NO'}, value='YES'},
  --{name='resolution', title='Screen resolution', options={'1280x1024', '1024x800', '800x600', '640x480', '320x240', '256x192'}, value='1024x800'},
  {name='resolution', title='Screen resolution', options={}, value=nil},
  {name='fullscreen', title='Fullscreen', options={'YES', 'NO'}, value='NO'},
  {name='quit', title='Quit'}
}
 
local modes=lg.getModes()
for k,v in ipairs(modes) do
  Options[4].options[k]=v.width..'x'..v.height
  if v.width==ORGWIDTH and v.height==ORGHEIGHT then
    Options[4].value=Options[4].options[k]
  end
end
table.insert(Options[4].options, '256x192')
if not Options[4].value then
  Options[4].value=Options[4].options[1]
end
local Menu={
  currentOption=1
}


function Menu:draw()
  for k,v in ipairs(Options) do
    if k==self.currentOption then
      lg.setColor(50,50,255)
    else
      lg.setColor(50,50,50)
    end
    if v.value then
      lg.printf(string.format('%s [%s]', v.title, v.value), 0, (2+k)*CellSize*2, W, 'center')
    else
      lg.printf(v.title, 0, (2+k)*CellSize*2, W, 'center')
    end
  end
end

function Menu:keypressed(a, b)
  if a=='up' or a=='w' then
    self.currentOption=self.currentOption-1
    if self.currentOption==0 then self.currentOption=#Options end
    return
  elseif a=='down' or a=='s' then
    self.currentOption=self.currentOption+1
    if self.currentOption>#Options then self.currentOption=1 end
    return
  elseif a=='enter' or a=='return' then
    self:onSelect(Options[self.currentOption].name)
  end
  local o=Options[self.currentOption]
  if o.options then
    local idx, previdx
    for k,v in ipairs(o.options) do
      if v==o.value then
        idx=k
        previdx=k
        break
      end
    end
    if a=='right' or a=='d' then
      idx=idx+1
      if idx>#o.options then idx=1 end
    elseif a=='left' or a=='a' then
      idx=idx-1
      if idx<1 then idx=#o.options end
    end
    if previdx~=idx then
      o.value=o.options[idx]
      self:onChange(o.name, o.value)
    end
  else
    if a=='right' or a=='left' or a=='d' or a=='a' then
      self:onSelect(o.name)
    end
  end
end

function Menu:onChange(k, v)
  if k=='resolution' then
    local w, h=v:match('(%d+)x(%d+)')
    resize(w, h)
  end
  if k=='fullscreen' then
    if v=='YES' then
      fullscreen=true
    else
      fullscreen=false
    end
    resize(W, H)
  end
  if k=='diagonal' then
    if v=='YES' then
      diagonal=true
    else
      diagonal=false
    end
  end
end
function Menu:onSelect(k)
  if k=='quit' then
    love.event.quit()
  elseif k=='play' then
    mode='play'
    initGame()
  elseif k=='help' then
    mode='help'
  end
end
return Menu

