-- src/entities/player.lua
local Player = {}

function Player.new(world, x, y)
    local self = {
        x = x or 400,
        y = y or 300,
        width = 32, -- Ancho del rectángulo (coincide con el sprite)
        height = 64, -- Alto del rectángulo
        body = nil,
        shape = nil,
        fixture = nil,
        sprite = nil,

        stats = {
            hp = 100,
            curr_hp = 100,
            dmg = 1,
            speed = 200
        }

    }
    self.sprite = love.graphics.newImage("assets/sprites/pjtest.png")
    self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.body:setFixedRotation(true)
    self.fixture:setUserData({
        type = "player",
        object = self
    })

    function self:update(dt, input)
        if not input or not input.isDown then
            print("Error: input no válido en player:update")
            return
        end

        local vx, vy = 0, 0
        if input.isDown('w') then
            vy = -self.stats.speed
        end
        if input.isDown('s') then
            vy = self.stats.speed
        end
        if input.isDown('a') then
            vx = -self.stats.speed
        end
        if input.isDown('d') then
            vx = self.stats.speed
        end

        if vx ~= 0 and vy ~= 0 then
            local mag = math.sqrt(vx ^ 2 + vy ^ 2)
            vx = vx * self.stats.speed / mag
            vy = vy * self.stats.speed / mag
        end

        self.body:setLinearVelocity(vx, vy)

        self.x, self.y = self.body:getPosition()

        -- Depuración
        -- print("Velocidad: vx=" .. vx .. ", vy=" .. vy)
    end

    function self:draw()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.sprite, self.x - self.width, self.y - self.height / 2)
        -- Depuración: dibujar contorno del rectángulo físico
        -- love.graphics.setColor(1, 0, 0) -- Rojo
        -- love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
    end

    return self
end

return Player
