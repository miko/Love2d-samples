function love.load()
  CELLSIZE=32
  PLAYERSIZE=16

  Player={x=92, y=100, G=-100, S=100, jumping=false, falling=false, Cells={}}
  createMap()
end

function love.update(dt)
  playermove(dt)
end

function love.draw()
  love.graphics.setColor(1,1,1)
  for y=1,#map do
    for x=1,#map[y] do
      if map[y][x] == 1 then
        love.graphics.rectangle("fill",x*CELLSIZE,y*CELLSIZE,CELLSIZE,CELLSIZE)
      else
        if DEBUG then
          love.graphics.rectangle("line",x*CELLSIZE,y*CELLSIZE,CELLSIZE,CELLSIZE)
        end
      end
    end
  end
  love.graphics.setColor(1,0,0,0.5)
  love.graphics.rectangle("fill",Player.x,Player.y,PLAYERSIZE, PLAYERSIZE)
  if DEBUG then
    love.graphics.setColor(0,1,0)
    love.graphics.print(string.format("Player at (%06.2f , %06.2f) jumping=%s falling=", Player.x, Player.y, tostring(Player.jumping), tostring(Player.falling)), 50,0)
    love.graphics.print(string.format("Player occupies cells(%d): %s", #Player.Cells, table.concat(Player.Cells, ' | ')), 450,0)
  end
end

-- is user off map?
function isOffMap(x, y)
  if x<CELLSIZE or x+PLAYERSIZE> (1+#map[1])*CELLSIZE
   or y<CELLSIZE or y+PLAYERSIZE>(1+#map)*CELLSIZE 
  then
    return true
  else
    return false
  end
end

function createMap()
  map = {
      {0,0,0,0,0,0,0,0,0,0,},
      {0,0,0,1,0,0,0,0,0,0,},
      {0,0,0,0,0,0,0,0,1,0,},
      {0,0,0,0,0,0,0,1,0,0,},
      {0,0,0,1,0,0,0,0,0,0,},
      {0,0,0,0,0,0,1,0,0,0,},
      {1,1,1,1,1,1,1,1,1,1,},
  }
end

-- which tile is that?
function posToTile(x, y)
  local tx=math.floor(x/CELLSIZE)
  local ty=math.floor(y/CELLSIZE)
  return tx, ty
end

-- Find out which cells are occupied by a player (check for each corner)
function playerOnCells(x, y)
  local Cells={}
  local tx,ty=posToTile(x, y)
  local key=tx..','..ty
  Cells[key]=true
  Cells[#Cells+1]=key

  tx,ty=posToTile(x+PLAYERSIZE, y)
  key=tx..','..ty
  if not Cells[key] then
    Cells[key]=true
    Cells[#Cells+1]=key
  end

  tx,ty=posToTile(x+PLAYERSIZE, y+PLAYERSIZE)
  key=tx..','..ty
  if not Cells[key] then
    Cells[key]=true
    Cells[#Cells+1]=key
  end

  tx,ty=posToTile(x, y+PLAYERSIZE)
  key=tx..','..ty
  if not Cells[key] then
    Cells[key]=true
    Cells[#Cells+1]=key
  end
  return Cells
end

local isDown = love.keyboard.isDown
function playermove(dt)
  -- Moving right or left?
  local newX, newY
  if isDown("left") then
    newX=Player.x-Player.S*dt
  end
  if isDown("right") then
    newX=Player.x+Player.S*dt
  end
  if newX then -- trying to move to a side
    local offmap=isOffMap(newX, Player.y)
    local colliding=isColliding(playerOnCells(newX, Player.y))
    if not offmap and not colliding then
      Player.x=newX
    end
  end

  -- jumping up or falling down
  Player.G = Player.G + Player.S*dt

  if not Player.jumping and isDown("space") and not Player.falling then
    Player.jumping = true 
    Player.G = -100
  end

    -- check only for upper or lower collision
  newY= Player.y + Player.G*dt -- always falling

  local coll=isColliding(playerOnCells(Player.x, newY))
  if coll then
    if Player.G>=0 then -- falling down on the ground
      Player.jumping=false
      Player.falling=false
    end
    Player.G=0
  else
    Player.falling=true -- falling down
  end

  if not isOffMap(Player.x, newY) and not coll then
    Player.y=newY
  end
  if DEBUG then
    Player.Cells=playerOnCells(Player.x, Player.y) -- 
  end
end

-- list of tiles
function isColliding(T)
  local collision=false
  for k,v in ipairs(T) do
    local x,y=v:match('(%d+),(%d+)')
    x,y=tonumber(x), tonumber(y)
    if not map[y] or not map[y][x] then
      collision=true -- off-map
    elseif map[tonumber(y)][tonumber(x)] == 1 then
      collision=true
    end
  end
  return collision
end

function love.keypressed(k)
  if k=='escape' then
    love.event.quit()
  end
  if k=='d' then DEBUG=not DEBUG end
end

