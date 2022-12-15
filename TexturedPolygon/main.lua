
-- Parameters:
--  target - framebuffer with black/white pixels
--  texture - file name or imageData
-- Returns:
--  Image
function texturize(target, texture)
  if type(texture)=='string' then
    texture=love.image.newImageData(texture)
  end
  tx, ty=texture:getWidth(), texture:getHeight()
  local function placeTexture(x, y, r, g, b, a)
    if r+g+b==0 then -- black
      return 0,0,0,0
    else -- non-black, needs a texture
      return texture:getPixel(x%tx, y%ty)
    end
  end
  local id=target:newImageData()
  id:mapPixel(placeTexture)
  return love.graphics.newImage(id)
end

-- make texturized polygon
function makePolygon(V, texture)
  local t=love.image.newImageData(texture)

  local minX, maxX, minY, maxY
  for n=1,#V, 2 do
    if not minX or minX>V[n] then minX=V[n] end
    if not maxX or maxX<V[n] then maxX=V[n] end
    if not minY or minY>V[n+1] then minY=V[n+1] end
    if not maxY or maxY<V[n+1] then maxY=V[n+1] end
  end
  local w,h=maxX-minX+1, maxY-minY+1
  local fb
  if love.graphics.newCanvas then -- 0.8+
    fb=love.graphics.newCanvas(w, h)
  else --0.7
    fb=love.graphics.newFramebuffer(w, h)
  end
  love.graphics.setCanvas(fb)
  love.graphics.setColor(255,255,255)
  love.graphics.translate(-minX, -minY)
  love.graphics.polygon('fill', V)
  love.graphics.translate(minX, minY)
  love.graphics.setCanvas()
  return texturize(fb, texture)
end

function love.load()
  local vertices={0,0, 100,0, 200,100, 100,400, 0,300, -100,200, 0,0}
  local textures={'face-crying.png', 'face-grin.png', 'face-plain.png', 'face-sad.png', 'face-smile-big.png', 'face-smile.png', 'face-surprise.png', 'face-wink.png'}
  Polygons={}
  for k,v in ipairs(textures) do
    Polygons[k]=makePolygon(vertices, v)
  end
  X, Y, r=200,200,0
end

function love.draw()
  local idx=math.floor(5*r%#Polygons)+1
  love.graphics.draw(Polygons[1], X-5, Y-5, 0, 1, 1, X, Y)
  love.graphics.draw(Polygons[idx], X, Y, r, 1, 1, X, Y)
end

function love.update(dt)
  r=r+dt
end

