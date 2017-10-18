local lg = love.graphics

function love.load()
  -- Screen width and height
  W, H = lg.getWidth(), lg.getHeight()

  -- Generating obstacles
  math.randomseed(os.time())
  local w, h = 40, 40
  Obstacles = {}
  for i = 1, 20 do
    table.insert(Obstacles, { x = math.random(W - w), y = math.random(H - h), w = w, h = h})
  end

  -- Creating the cursor
  w, h = 20, 20 -- Width and height of the cursor (the player)
  Cursor = { x = math.random(W - w), y = math.random(H - h), w = w, h = h, speed = 100}

  -- Making sure Cursor doesn't spawn on an obstackle
  while willCollide() do
    Cursor.x, Cursor.y = math.random(W - w), math.random(H - h)
  end

  collision = false
end

function love.draw()
  -- Drawing obstacles
  lg.setColor(255, 0, 0, 255)
  for _, v in ipairs(Obstacles) do
    lg.rectangle('fill', v.x, v.y, v.w, v.h)
  end

  -- Drawing cursor
  lg.setColor(0, 255, 0, 255)
  lg.rectangle('fill', Cursor.x, Cursor.y, Cursor.w, Cursor.h)
  lg.setColor(255, 255, 255, 255)

  if collision then
    lg.print('COLLISION!!!', W/2, 0)
  end
end

local isDown = love.keyboard.isDown
function love.update(dt)
  -- Handle movement
  local dx, dy = 0, 0

  if isDown('right') or isDown('d') then
    dx = dx + 1
  end

  if isDown('left') or isDown('a') then
    dx = dx - 1
  end

  if isDown('up') or isDown('w') then
    dy = dy - 1
  end

  if isDown('down') or isDown('s') then
    dy = dy + 1
  end

  -- Calculate the next position of the cursor
  -- (dt is needed to balance movement speed for different processors)
  local nextX = Cursor.x + dx * Cursor.speed * dt
  local nextY = Cursor.y + dy * Cursor.speed * dt

  if willBeOnScreen(nextX, nextY) and not willCollide(nextX, nextY) then
  	Cursor.x = nextX
    Cursor.y = nextY
    collision = false
  else
  	collision = true
  end
end

-- Checks if the cursor will be on screen in the next frame
function willBeOnScreen(nextX, nextY)
  nextX = nextX or Cursor.x
  nextY = nextY or Cursor.y

  if nextX > 0 and nextX + Cursor.w < W and
     nextY > 0 and nextY + Cursor.h < H then
    return true
  else
    return false
  end
end

-- Checks if cursor which will have the given X and Y will collide with an object
function willColllideWith(obj, nextX, nextY)
  nextX = nextX or Cursor.x
  nextY = nextY or Cursor.y
  local ox, oy = obj.x - nextX, obj.y - nextY -- let's pretend Cursor is at (0, 0)
  if ox + obj.w < 0 or oy + obj.h < 0 or
    ox > Cursor.w or oy > Cursor.h then
    return false
  else
    return true
  end
end

-- Checks if the cursor will collide with any object in the next frame
function willCollide(nextX, nextY)
  for _,v in ipairs(Obstacles) do
    if willColllideWith(v, nextX, nextY) then
      return true
    end
  end
  return false
end
