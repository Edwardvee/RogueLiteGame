-- src/entities/cursor.lua
local HitDirection = {}

function HitDirection.new(player, mouse)
    local self = {
        player = player, -- Referencia al objeto player
        mouse = mouse, -- Referencia al objeto mouse
        spriteWidth = 16, -- Ajustar según el tamaño real de cursor.png
        spriteHeight = 16,
        distance = 50, -- Distancia desde el centro del jugador (radio 20 + margen)
        x = 0, -- Posición del cursor (calculada)
        y = 0,
        angle = 0 -- Ángulo hacia el mouse
    }

    -- Cargar sprite
    self.sprite = love.graphics.newImage("assets/sprites/cursor.png")

    function self:update()
        -- Obtener posición del jugador
        local playerX, playerY = self.player.x, self.player.y
        -- Obtener posición del mouse
        local mouseX, mouseY = self.mouse.x, self.mouse.y

        -- Calcular ángulo hacia el mouse
        self.angle = math.atan2(mouseY - playerY, mouseX - playerX)

        -- Calcular posición del cursor (orbita alrededor del jugador)
        self.x = playerX + math.cos(self.angle) * self.distance
        self.y = playerY + math.sin(self.angle) * self.distance
    end

    function self:draw()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.sprite, self.x, self.y, self.angle + math.pi / 2, 1, 1, self.spriteWidth / 2,
            self.spriteHeight / 2) -- Ajusta aquí el +4 si la punta del cursor está descentrada (prueba 0 a 8)
    end

    return self
end

return HitDirection
