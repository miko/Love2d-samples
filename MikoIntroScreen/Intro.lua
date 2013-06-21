require 'class'

--love=love or {graphics={}} -- plain lua compatibility
local lg=love.graphics
if not lg.newFramebuffer then
  lg.newFramebuffer=lg.newCanvas -- love 0.8 compatilibity
end

local WIDTH, HEIGHT=lg.getWidth(), lg.getHeight()
local _SAVED={}
local iterator

local empty=function() end
local function save()
  for k,v in pairs({'draw', 'update', 'keypressed', 'keyreleased'}) do
    _SAVED[v]=love[v] or empty
  end
end

local function restore()
  for k,v in pairs(_SAVED) do
    if v==empty then
      love[k]=nil
    else
      love[k]=v
    end
  end
end

local function tween(pct, sval, eval)
  return sval+pct/100*(eval-sval)
end

local function srand(x, y)
  return math.floor(math.random(x, y))
end

local function makeSample(len, pitch)
  len=len or 0.1
  pitch=pitch or 440
  local overtime=1.5
  local tick = love.sound.newSoundData(overtime*len * 44100, 44100, 16, 1)
  for i = 0,len*44100*overtime do
    local t = i / 44100
    local sample = math.sin(t * pitch * math.pi * 2) * len
    tick:setSample(i, sample)
  end
  return tick
end

                                                        
local O=class(function(self, data, ctype)
  OBJNAME=(OBJNAME or 0)+1
  self.name=OBJNAME
  if ctype then
    self.ctype=ctype
  end
  if type(data)=='string' then
    if not ctype then
      self.ctype='text'
    end
    self.text=data or '???'
  else
    if not ctype then
      self.ctype='image'
    end
  end
  self.data=data
end)

function O:setPosition(x, y)
  self.x, self.y=x or 0, y or 0
  return self
end
function O:setRotation(r)
  self.r=r or 0
  return self
end
function O:setScale(sx, sy)
  sx=sx or 1
  if not sy then sy=sx end
  self.sx, self.sy=sx, sy
  return self
end
function O:setFont(font)
  if type(font)=='number' then
    font=self:getFont(font)
  end
  self.font=font or ''
  return self
end
function O:setColor(r, g, b, a)
  local color
  if type(r)=='table' then
    color=r
  else
    color={r, g, b, a}
  end
  self.color=color
  return self
end

function O:center()
  if self.ctype~='text' then
    return
  end
  local w=self:getFont():getWidth(self.text)
  self.x=(WIDTH-w)/2
  return self
end

function O:start()
  self._DATA={}
  if self.ctype=='text' then
    local font=self:getFont()
    local rot=self.r
    lg.setFont(font)
    local H=font:getHeight()
    local dw=0
    for c in self.text:gmatch('.') do
      local W=font:getWidth(c)
      local o={x=self.x+dw, y=self.y, sx=srand(0, WIDTH), sy=srand(0, HEIGHT), char=c}
      o.scolor={srand(0, 255), srand(0, 255),srand(0, 255)}
      o.r=rot
      o.sr=srand(0, 360*4)
      dw=dw+W
      o.fb=lg.newFramebuffer(W, H)

      o.cx, o.cy=W/2, H/2
      o.sSX=math.random(100)/10
      lg.setCanvas(o.fb)
      lg.print(c, 0, 0)
      table.insert(self._DATA, o)
    end
  elseif self.ctype=='image' then
    local o={x=self.x, y=self.y, sx=srand(0, WIDTH), sy=srand(0, HEIGHT)}
    o.r=self.r
    o.sr=srand(0, 360*4)
    local W, H=self.data:getWidth(), self.data:getHeight()
    o.cx, o.cy=W/2, H/2
    o.sSX=math.random(100)/10
    o.fb=self.data
    self._DATA[1]=o
  elseif self.ctype=='audio' then
    love.audio.play(self.data)
  end
end

function O:stop()
  if self.ctype=='audio' then
    love.audio.stop(self.data)
  end
end

function O:getFont(size)
  if not self.font then 
    lg.setNewFont(size) 
    self.font=lg.getFont() 
  end
  return self.font
end

function O:draw(pct)
  lg.setColor(255, 255, 255, 255)
  local color=self.color
  local A=tween(pct, 0, 255)
  if self.ctype=='text' then
    for k,v in ipairs(self._DATA) do
      local x=tween(pct, v.sx, v.x)
      local y=tween(pct, v.sy, v.y)
      local scolor=v.scolor

      local R=tween(pct, scolor[1], color[1])
      local G=tween(pct, scolor[2], color[2])
      local B=tween(pct, scolor[3], color[3])
      local rot=tween(pct, v.sr or 0, self.r or 0)
      local sx=tween(pct, v.sSX, 1)
      --local sy=tween(pct, v.sSY, 1)
      if self.hilited==k then
        lg.setColor(255, 255, 255, 255)
      else
        lg.setColor(R, G, B, A)
      end
      lg.push()
      lg.translate(x+v.cx, y+v.cy)
      lg.rotate(math.rad(rot))
      lg.translate(-v.cx, -v.cy)
      --lg.scale(sx, sx)
      lg.draw(v.fb, 0, 0)
      lg.pop()
    end
  elseif self.ctype=='image' then
    local v=self._DATA[1]
    local x=tween(pct, v.sx, v.x)
    local y=tween(pct, v.sy, v.y)
    local scolor=v.scolor

    --[[
    local R=tween(pct, scolor[1], color[1])
    local G=tween(pct, scolor[2], color[2])
    local B=tween(pct, scolor[3], color[3])
    --]]
    local rot=tween(pct, v.sr or 0, self.r or 0)
    local sx=tween(pct, v.sSX, 1)
    lg.setColor(255, 255, 255, A)
    --local sy=tween(pct, v.sSY, 1)
    --lg.setColor(R, G, B)
    lg.push()
    --lg.scale(sx, sx)
    lg.translate(x+v.cx, y+v.cy)
    lg.rotate(math.rad(rot))
    lg.translate(-v.cx, -v.cy)
    lg.draw(v.fb, 0, 0)
    lg.pop()
  end
end

function O:setHilited(id)
  self.hilited=id
end

function O:__tostring()
  return string.format('<Object %s %s>', self.ctype, self.name or 'unnamed')
end

local Object=O

--
local M=class(function(self)
  self.Objects={}
  self:setDuration(6)
  self:setDelay(2)
end)

function M:addText(txt)
  local obj=Object(txt)
  table.insert(self.Objects, obj)
  return obj
end

function M:addImage(filename)
  local img
  if type(filename)=='string' then
    img=lg.newImage(filename)
  else
    img=filename
  end
  local obj=Object(img)
  table.insert(self.Objects, obj)
  return obj
end

function M:addAudio(audio)
  if type(audio)=='string' then
    audio=love.audio.newSource(audio, 'static')
  end
  local obj=Object(audio, 'audio')
  table.insert(self.Objects, obj)
  return obj
end
function M:setDuration(d)
  self.duration=d or 6
  return self
end

function M:setDelay(d)
  self.delay=d or 2
  return self
end

function M:makeChaos()
  return self
end

-- len - in seconds, just before duration
function M:setBlinks(len, obj, ...)
  if not obj then return self end
  self.blink=len
  self.blinkObjects=self.blinkObjects or {}
  table.insert(self.blinkObjects, obj)
  return self:setBlinks(len, ...)
end

function M:_setupBlinks()
  local count=0
  for k,v in pairs(self.blinkObjects) do
    count=count+#v._DATA
  end
  self.blinkChars=count
  self.blinkdt=self.blink/count
  function self.nextCharIterator()
    local T=self.blinkObjects
    local objKey,obj=next(T)
    local idxKey, idx
    return function()
      idxKey, idx=next(obj._DATA, idxKey)
      if not idx then
        objKey,obj=next(T, objKey)
        if not obj then return end
        idxKey, idx=next(obj._DATA, idxKey)
      end
      return obj, idxKey, idx
    end
  end
  SAMPLES={}
  for obj, idxk, idxo in self:nextCharIterator() do
    local c=idxo.char:upper()
    if not SAMPLES[c] then
      local x=0
      if c==' ' then
        x=1
      elseif c=='!' then
        x=2
      else
        x=c:byte()-45 -- 49 for "0", 65 for "A"
      end
      SAMPLES[c]=makeSample(self.blinkdt, 2^((x-2)/12)*400)
    end
  end
end

function M:start()
  local s=self
  save()
  math.randomseed(os.time())
  love.update=function(dt) s:update(dt) end
  love.draw=function() s:draw() end
  love.keypressed=function(a, b) s:keypressed(a, b) end
  self.elapsed=0
  lg.setColor(255, 255, 255, 255)
  for k,v in ipairs(self.Objects) do
    v:start()
  end
  lg.setCanvas()
  if self.blink then
    self:_setupBlinks()
  end
  return self
end

function M:stop()
  for k,v in ipairs(self.Objects) do
    v:stop()
  end
  restore()
  return self
end

function M:keypressed(a, b)
  if a==' ' then
    self.paused=not self.paused
  else
    self:stop()
  end
end

function M:update(dt)
  if self.paused then return end
  self.elapsed=self.elapsed+dt
  if self.elapsed>self.duration+self.delay then
    self:stop()
  elseif self.elapsed>self.duration then
    if self.pct~=100 then
      self.pct=100
    end

    if self.blink and self.elapsed-self.duration<=self.blink then
      BLINKDT=(BLINKDT or 0)+dt
      if BLINKDT>self.blinkdt then
        BLINKDT=BLINKDT-self.blinkdt
        if self.objHilited then
          self.objHilited:setHilited()
        end

        --local obj=self.blinkObjects[math.random(1, #self.blinkObjects)]
        iterator=iterator or self:nextCharIterator()
        local obj, idxk, idxo=iterator()
        SRC=SRC or {}
        local src=love.audio.newSource(SAMPLES[idxo.char:upper()])
        src:setVolume(2)
        src:play()
        SRC[#SRC+1]=src
        --obj:setHilited(math.random(#obj._DATA))
        obj:setHilited(idxk)
        self.objHilited=obj
      end
    else
      if self.objHilited then
        self.objHilited:setHilited()
      end
    end

    return
  end
  self.pct=self.elapsed/self.duration*100
end

function M:draw()
  local pct=self.pct
  if not pct then return end
  for k,v in ipairs(self.Objects) do
    v:draw(pct)
  end
end

return M
