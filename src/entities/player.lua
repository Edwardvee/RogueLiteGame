-- src/entities/player.lua
local Player = {}

function Player.new(x, y)
    local self = {
        x = x or 400,
        y = y or 300,
        radius = 20,
        speed = 200,
        vx = 0,
        vy = 0
    }

    function self:update(dt, input)
        if not input or not input.isDown then
            print("Error: input no válido en player:update")
            return
        end

        -- Reiniciar velocidades
        self.vx = 0
        self.vy = 0

        -- Actualizar velocidad según input
        if input.isDown('w') then
            self.vy = -self.speed
        end
        if input.isDown('s') then
            self.vy = self.speed
        end
        if input.isDown('a') then
            self.vx = -self.speed
        end
        if input.isDown('d') then
            self.vx = self.speed
        end

        -- Depuración: mostrar velocidades calculadas
        print("Velocidad: vx=" .. self.vx .. ", vy=" .. self.vy)

        -- Normalizar velocidad diagonal
        if self.vx ~= 0 and self.vy ~= 0 then
            local mag = math.sqrt(self.vx ^ 2 + self.vy ^ 2)
            self.vx = self.vx * self.speed / mag
            self.vy = self.vy * self.speed / mag
        end

        -- Actualizar posición
        self.x = self.x + self.vx * dt
        self.y = self.y + self.vy * dt

        -- Limitar al área de la pantalla
        self.x = math.max(self.radius, math.min(self.x, love.graphics.getWidth() - self.radius))
        self.y = math.max(self.radius, math.min(self.y, love.graphics.getHeight() - self.radius))
    end

    function self:draw()
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", self.x, self.y, self.radius)
    end

    return self
end

return Player
