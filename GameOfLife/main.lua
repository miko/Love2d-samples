-- Game of Life by miko
-- Controls:
-- 0, 1, 2 - set cell border width
-- left,right - decrease/increase no of columns
-- up, down - decrease/increase no of rows
-- +/- - increase/decrease cell size
-- n - next cell generation
-- r,space - toggle running mode
-- c - clear the table
-- x - make some random cells alive
-- q,escape - quit
-- left mouse button - toggle cell dead/alive
-- right mouse button - check the status of a cell

local lg=love.graphics

function love.load()
  rows, cols=30,30
  cellsize=20
  lineWidth=1+1
  elapsed=0
  tick=0.1
  fb=lg.newFramebuffer()
  lg.setFont(20)
  status=nil
  init()
end

function init()
  CELLS={}
  for c=1,cols do
    CELLS[c]={}
    for r=1,cols do
      CELLS[c][r]=false
    end
  end
  generation=1
end

function love.draw()
  if not cached then
    cached=true
    lg.setRenderTarget(fb)
    if lineWidth>0 then
      lg.setLineWidth(lineWidth)
    end
    for c=1,cols do
      for r=1,rows do
        local cell=CELLS[c][r]
        if cell then
          lg.setColor(255,0,0,255)
        else
          lg.setColor(0,0,0,255)
        end
        lg.rectangle('fill', (c-1)*cellsize, (r-1)*cellsize, cellsize, cellsize)
        if lineWidth>0 then
          lg.setColor(255,255,255,255)
          lg.rectangle('line', (c-1)*cellsize, (r-1)*cellsize, cellsize, cellsize)
        end
      end
    end
    lg.setRenderTarget()
  end
  lg.setColor(255,255,255,255)
  lg.draw(fb, 0, 0, 0)
  local msg=string.format("Cols=%d Rows=%d CellSize=%d Gen=%d %s RUNNING FPS=%d ", cols, rows, cellsize, generation, running and '' or 'NOT', love.timer.getFPS())
  if status then msg=msg.."\n"..status end

  lg.setColor(0,255,0,255)
  lg.print(msg, 0,0,0)
  lg.setColor(0,0,255,255)
  lg.print(msg, 1,1,0)
  lg.setColor(255,0,0,255)
  lg.print(msg, 2,2,0)
end

function mouse2cell(x, y)
  local cx, cy=math.floor(x/cellsize), math.floor(y/cellsize)
  if cx>=0 and cx<cols and cy>=0 and cy<rows then
    return cy+1, cx+1
  end
end

function love.update(dt)
  if not running then return end
  elapsed=elapsed+dt
  if elapsed>=tick then
    elapsed=elapsed-tick
    nextGeneration()
    cached=nil
  end
end

function love.mousepressed(x, y, b)
  --local cx, cy=mouse2cell(x, y)
  local mr, mc=mouse2cell(x, y)
  status=nil
  if mr then
    if b=='l' then
      CELLS[mc][mr]=not CELLS[mc][mr] 
      status=string.format('Cell c=%d,r=%d changed to %s', mc, mr, CELLS[mc][mr] and 'ALIVE' or 'DEAD')
    elseif b=='r' then
      status=string.format('Cell c=%d,y=%d %s neighbours: %d', mc, mr, CELLS[mc][mr] and 'ALIVE' or 'DEAD', countNeighbours(mc, mr))
    end
    cached=nil
  end
  
end

function love.keypressed(a, b)
  if a=='q' or a=='escape' then
    love.event.push("q")
  end
  if a=='r' or a==' ' then
    running=not running
  end
  if a=='n' then
    nextGeneration()
    cached=nil
  end
  if a=='c' then
    init()
    cached=nil
  end
  if a=='1' or a=='2' or a=='0' then
    lineWidth=tonumber(a)
    cached=nil
  end
  if a=='down' then
    rows=rows+1
    cached=nil
    init()
  end
  if a=='up' then
    rows=rows-1
    cached=nil
    init()
  end
  if a=='right' then
    cols=cols+1
    cached=nil
    init()
  end
  if a=='left' then
    cols=cols-1
    cached=nil
    init()
  end
  if a=='+' or a=='=' then
    cellsize=math.min(cellsize+1, 30)
    cached=nil
  end
  if a=='-' or a=='_' then
    cellsize=math.max(cellsize-1, 1)
    cached=nil
  end
  if a=='x' then
    for i=1,cols*rows*0.1 do
      CELLS[math.random(1,cols)][math.random(1, rows)]=true
    end
    cached=nil
  end
end

function countNeighbours(c, r)
  local n=0
  local cy=c
  local cx=r
  if cx>1 and cy>1 then
    if CELLS[cy-1][cx-1] then n=n+1 end
  end
  if cy>1 then
    if CELLS[cy-1][cx] then n=n+1 end
  end
  if cx<cols and cy>1 then
    if CELLS[cy-1][cx+1] then n=n+1 end
  end

  if cx>1 then
    if CELLS[cy][cx-1] then n=n+1 end
  end
  if cx<cols then
      if CELLS[cy][cx+1] then n=n+1 end
  end

  if cx>1 and cy<rows then
    if CELLS[cy+1][cx-1] then n=n+1 end
  end
  if cy<rows then
    if CELLS[cy+1][cx] then n=n+1 end
  end
  if cx<cols and cy<rows then
    if CELLS[cy+1][cx+1] then n=n+1 end
  end
  return n
end

function nextGeneration()
  generation=generation+1
  local NEWCELLS={}
  --for c, COL in ipairs(CELLS) do
  for c=1,cols do
    NEWCELLS[c]={}
    --for r, cell in ipairs(COL) do
    for r=1, rows do
      local cell=CELLS[c][r]
      --local n=countNeighbours(r, c)
      local n=countNeighbours(c, r)
      if cell then
        if n==2 or n==3 then
          NEWCELLS[c][r]=true
        else
          NEWCELLS[c][r]=false
        end
      else
        if n==3 then
          NEWCELLS[c][r]=true
        else
          NEWCELLS[c][r]=false
        end
      end

    end
  end
  CELLS=NEWCELLS
end
