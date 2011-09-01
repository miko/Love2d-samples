
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
      return 0,0,0,128
    else -- non-black, needs a texture
      return texture:getPixel(x%tx, y%ty)
    end
  end
  local id=target:getImageData()
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
  local fb=love.graphics.newFramebuffer(w, h)
  love.graphics.setRenderTarget(fb)
  love.graphics.setColor(255,255,255)
  love.graphics.translate(-minX, -minY)
  love.graphics.polygon('fill', V)
  love.graphics.translate(minX, minY)
  love.graphics.setRenderTarget()
  return texturize(fb, texture)
end

function love.load()
  polygon=makePolygon({0,0, 100,0, 200,100, 100,400, 0,300, -100,200, 0,0}, 'texture.png')
  X, Y=100,100
end

function love.draw()
  love.graphics.draw(polygon, X, Y)
end


