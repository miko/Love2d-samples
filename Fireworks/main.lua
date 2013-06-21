FireworkEngine=require 'FireworkEngine'
function love.load()
  FE=FireworkEngine()
  love.graphics.setBlendMode('additive')
end

function  love.update(dt)
  FE:update(dt)
end

function love.draw()
  FE:draw()
end

function love.mousepressed(x, y, b)
  if b=='l' then
    FE:addFirework(x, y)
  end
end

function love.keypressed(k)
  if k=='q' or k=='escape' then
    love.event.quit()
  end
end

