local CodeCapture=require 'CodeCapture'

function love.load()
  CodeCapture.setCode("qwerty", function() MODE='ONE' end)
  CodeCapture.setCode('second', function() MODE='TWO' end)
  CodeCapture.setCode('secundo', function() MODE='DUO' end)
  CodeCapture.setCode(CodeCapture.KONAMI, function() MODE='KONAMI' end)
  CodeCapture.setCode({'a','mouse-1','b','mouse-2'}, function() MODE='WITH MOUSE' end)
  CodeCapture.setCode('quit', function() love.event.quit() end)
  CodeCapture.setCode('exit', function() love.event.quit() end)

  MODE='NONE'
end

function love.draw()
  love.graphics.print(MODE, 10, 10)
end

function love.keypressed(a)
  CodeCapture.keypressed(a)
end

function love.mousepressed(x,y,b)
  CodeCapture.keypressed('mouse-'..b)
end

