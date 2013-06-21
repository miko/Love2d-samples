local lg=love.graphics
ORGWIDTH, ORGHEIGHT=lg.getWidth(), lg.getHeight()
local Menu=require 'menu'

function love.load()
  ReplayDelay=0.2
  lg.setBackgroundColor(255,255,255)
  mode='menu'
  fullscreen=false
  diagonal=true
  initScreen()
  initGame()
end

function initScreen()
  W, H=lg.getWidth(), lg.getHeight()
  --CellSize=30
  CellSize=math.floor(math.min(W/25, H/25))

  CX,CY=math.floor(W/CellSize), math.floor(H/CellSize)
  BorderWidthX=(W-(CX-2)*CellSize)/2
  BorderWidthY=(H-(CY-2)*CellSize)/2
  CX,CY=CX-2,CY-2
  lg.setNewFont(CellSize)
end

function initGame()
  CenterX=math.floor(CX/2)
  PX, PY=CenterX, CY+1 -- player position
  Bombs, Visited={}, {}
  for x=1,CX do
    Bombs[x]={}
    Visited[x]={}
  end
  local bomblimit=math.floor(CX*CY/10)
  for i=1,bomblimit do
    local x,y=0,0
    repeat
      x, y=math.random(1, CX), math.random(1, CY)
    until not Bombs[x][y] and not (x==CenterX and (y==1 or y==CY))
    Bombs[x][y]=true
  end
  crashed=nil
  won=nil
  showingBombs=nil
  History={}
  elapsed=0
end

function drawCell(X, Y, Color)
  if Color then
    lg.setColor(Color)
  end
  lg.rectangle('fill', BorderWidthX+CellSize*(X-1), BorderWidthY+CellSize*(Y-1), CellSize, CellSize)
end

function drawPlayer(X, Y)
  lg.setColor(255, 255, 0)
  lg.circle('fill', BorderWidthX+CellSize*(X-0.5), BorderWidthY+CellSize*(Y-0.5), CellSize/2, CellSize)
end

function drawBomb(X, Y)
  lg.circle('fill', BorderWidthX+CellSize*(X-0.5), BorderWidthY+CellSize*(Y-0.5), CellSize/4, CellSize)
end

function drawBorders()
  lg.setColor(0, 0, 255)
  lg.rectangle('fill', 0, 0, W, BorderWidthY)
  lg.rectangle('fill', 0, H-BorderWidthY, W, BorderWidthY)
  lg.rectangle('fill', 0, 0, BorderWidthX, H)
  lg.rectangle('fill', W-BorderWidthX, 0, BorderWidthX, H)
  lg.setColor(0, 255, 0)
  drawCell(math.floor(CX/2), CY+1)
  drawCell(math.floor(CX/2), 0)
end

function drawVisited()
  lg.setColor(200, 100, 100)
  for x=1,CX do
    for y=1,CY do
      if Visited[x][y] then
        drawCell(x, y)
      end
    end
  end
end

function countBombs()
  local n=0
  if diagonal then
    for x=PX-1,PX+1 do
      for y=PY-1,PY+1 do
        if Bombs[x] and Bombs[x][y] then n=n+1 end
      end
    end
  else
    if Bombs[PX-1] and Bombs[PX-1][PY] then n=n+1 end
    if Bombs[PX+1] and Bombs[PX+1][PY] then n=n+1 end
    if Bombs[PX] and Bombs[PX][PY-1] then n=n+1 end
    if Bombs[PX] and Bombs[PX][PY+1] then n=n+1 end
  end
  return n
end

function drawMsgs()
  local n=countBombs()
  lg.setColor(255, 0, 0)
  lg.printf('Bombs: '..n, 0,0, W, 'right')
  lg.printf(string.format('Time: %d s', elapsed), 0,0, W, 'left')
  if replaying then
    lg.printf('Replaying...', 0, H/2, W, 'center')
  else
    if crashed then
      lg.printf('Bum!\n\nPress SPACE to play again, R for replay, M for menu', 0, H/2, W, 'center')
    end
    if won then
      lg.printf('Congratulations! You win in '..math.floor(elapsed)..' seconds!\n\nPress SPACE to play again, R for replay, M for menu', 0, H/2, W, 'center')
    end
  end
end

function drawBombs()
  lg.setColor(0, 0, 0)
  for x=1,CX do
    for y=1,CY do
      if Bombs[x][y] then
        drawBomb(x, y)
      end
    end
  end

end

function drawHelp()
  lg.setColor(0,0,0)
  lg.printf([[Your goal is to go from the bottom gate to the top gate of the minefield, without stepping on a mine. The counter at the top right corner shows the number of mines in all 8 neighbouring cells.

  Use cursor keys/ WASD for movement, q/ESCAPE for quit.

  In the menu you can change some options (screen resolution, etc).
  
  Press any key to return to menu, then select Play.]], W*0.2, H/5, W*0.6, 'center')
end

function love.draw()
  if mode=='help' then
    drawHelp()
    return
  elseif mode=='menu' then
    Menu:draw()
    return
  end

  drawBorders()
  drawVisited()
  drawPlayer(PX, PY)
  if showingBombs then
    drawBombs()
  end
  drawMsgs()
end

function replayGame()
  histIndex=1
  replaying=true
  Visited={}
  for x=1,CX do
    Visited[x]={}
  end
end

function love.keypressed(a, b)
  if a=='q' or a=='escape' then
    love.event.quit()
  end
  if mode=='menu' then
    Menu:keypressed(a, b)
    return
  elseif mode=='help' then
    mode='menu'
    return
  end
  if a=='b' then
    showingBombs=not showingBombs 
  end
  if replaying then return end
  if crashed or won then
    if a==' ' then
      initGame()
    end
    if a=='r' then
      replayGame()
    end
    if a=='m' then
      mode='menu'
    end
  else
    local moved
    if (a=='up' or a=='w') and (PY>1 or PX==CenterX) then PY=PY-1; moved=true end
    if (a=='down' or a=='s') and PY<CY then PY=PY+1; moved=true end
    if (a=='left' or a=='a') and PX>1 and PY<=CY then PX=PX-1; moved=true end
    if (a=='right' or a=='d') and PX<CX and PY<=CY then PX=PX+1; moved=true end
    if moved then
      table.insert(History, {PX, PY})
      if not Visited[PX][PY] then
        Visited[PX][PY]=true
      end
      if Bombs[PX][PY] then
        crashed=true
        showingBombs=true
      end
      if PY==0 then
        won=true
        showingBombs=true
      end
    end
  end
end

function love.update(dt)
  if mode=='play' and not crashed and not won then
    elapsed=elapsed+dt
  end
  if not replaying then return end
  timer=(timer or 0)+dt
  if timer>ReplayDelay then
    timer=timer-ReplayDelay
    local move=History[histIndex]
    histIndex=histIndex+1
    if not move then
      timer=nil
      replaying=nil
      histIndex=nil
    else
      PX, PY=unpack(move)
      Visited[PX][PY]=true
    end
  end
end

function resize(W, H)
  lg.setMode(W, H, fullscreen , true)
  initScreen()
end

function love.quit()
  fullscreen=false
  resize(ORGWIDTH, ORGHEIGHT)
end

