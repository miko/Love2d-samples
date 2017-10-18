local lg = love.graphics

function love.load()
  W, H = lg.getWidth(), lg.getHeight()
  local w, h = 40, 40
  Obstacles = {}

  for i = 1, 20 do
    table.insert(Obstacles, { x = math.random(W - w), y = math.random(H - h), w = w, h = h})
  end

  w, h = 20, 20
  Cursor = { x = math.random(W - w), y = math.random(H - h), w = w, h = h}

  while isColliding() do
    Cursor.x, Cursor.y = math.random(W - w), math.random(H - h)
  end

  collision = false
end

function love.draw()
  lg.setColor(255, 0, 0, 255)

  for _, v in ipairs(Obstacles) do
    lg.rectangle('fill', v.x, v.y, v.w, v.h)
  end

  lg.setColor(0, 255, 0, 255)
  lg.rectangle('fill', Cursor.x, Cursor.y, Cursor.w, Cursor.h)
  lg.setColor(255, 255, 255, 255)
  if collision then
    lg.print('COLLISION!!!', W/2, 0)
  end

end

local isDown = love.keyboard.isDown
function love.update(dt)
  local dx, dy = 0, 0
  if isDown('right') or isDown('d') then
    dx = 1
  elseif isDown('left') or isDown('a') then
    dx = -1
  elseif isDown('up') or isDown('w') then
    dy = -1
  elseif isDown('down') or isDown('s') then
    dy = 1
  end

  local currX, currY = Cursor.x, Cursor.y
  Cursor.x, Cursor.y = Cursor.x + dx, Cursor.y + dy
  collision = false
  if not isOnScreen() or isColliding() then
    Cursor.x, Cursor.y = currX, currY
    collision = true
  end
end

function isOnScreen()
  if Cursor.x > 0 and Cursor.x + Cursor.w < W and
     Cursor.y > 0 and Cursor.y + Cursor.h < H then
    return true
  else
    return false
  end
end

function isCollidingWith(obj)
  local ox, oy = obj.x - Cursor.x, obj.y - Cursor.y -- let's pretend Cursor is at (0,0)
  if ox + obj.w < 0 or oy + obj.h < 0 or
    ox > Cursor.w or oy > Cursor.h then
    return false
  else
    return true
  end
end

function isColliding()
  for _,v in ipairs(Obstacles) do
    if isCollidingWith(v) then
      return true
    end
  end
  return false
end
