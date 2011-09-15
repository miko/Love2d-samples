function love.conf(t)
	t.modules.joystick = false
	t.modules.audio = false
	t.modules.keyboard = true
	t.modules.event = true
	t.modules.image = false
	t.modules.graphics = true
	t.modules.timer = true
	t.modules.mouse = false
	t.modules.sound = false
	t.modules.physics = false
	t.console = false
	t.title = "Minefield"
	t.author = "MiKo"
	t.screen.fullscreen = false
	t.screen.vsync = true
	t.screen.fsaa = 0
	--t.screen.height = 800
	--t.screen.width = 1024
end
