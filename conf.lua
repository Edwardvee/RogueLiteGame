function love.conf(t)
    t.window.title = "RogueLaid"
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = true
    t.window.fullscreen = false -- cambiar a true para fullscreen
    t.window.fullscreentype = "desktop"
    t.modules.physics = true
    t.modules.keyboard = true
    t.modules.mouse = true
end

