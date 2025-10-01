-- src/entities/cursor.lua
anim8 = require("libs.anim8")
local PlayerAttack = {}

function PlayerAttack.new(player, mouse)
    local self = {
        player = player,
        mouse = mouse,
        spriteWidth = 8,
        spriteHeight = 16,
        distance = 35,
        x = 0,
        y = 0,
        angle = 0,
        clicked = false -- Para detectar un clic único
    }
    self.spriteSheet = love.graphics.newImage("assets/sprites/attackTest.png")
    self.spriteGrid = anim8.newGrid(8, 32, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animations = {}
    self.animations.baseAttack = anim8.newAnimation(self.spriteGrid("1-7", 1), 0.1)
    self.animations.baseAttack:pauseAtStart() -- Pausar en frame 1 inicialmente

    function self:update(dt)
        local playerX, playerY = self.player.x, self.player.y
        local mouseX, mouseY = self.mouse.x, self.mouse.y
        self.angle = math.atan2(mouseY - playerY, mouseX - playerX)
        self.x = playerX + math.cos(self.angle) * self.distance
        self.y = playerY + math.sin(self.angle) * self.distance

        if self.mouse.isDown(1) and not self.clicked and self.animations.baseAttack.status ~= "playing" then
            self.clicked = true
            self.animations.baseAttack:gotoFrame(1)
            self.animations.baseAttack:resume()
        elseif not self.mouse.isDown(1) then
            self.clicked = false
        end

        self.animations.baseAttack:update(dt)

        if self.animations.baseAttack.position == 7 then
            self.animations.baseAttack:gotoFrame(1)
            self.animations.baseAttack:pause()
        end
    end

    function self:draw()
        love.graphics.setColor(1, 1, 1)
        love.graphics.setDefaultFilter('nearest', 'nearest')
        self.animations.baseAttack:draw(self.spriteSheet, self.x, self.y, self.angle + math.pi, 2.5, 2.5,
            self.spriteWidth / 2, self.spriteHeight)
    end

    return self
end

return PlayerAttack
