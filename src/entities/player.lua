-- src/entities/player.lua
local Player = {}

function Player.new(world, x, y)
    local self = {
        x = x or 400,
        y = y or 300,
        width = 64, -- Ancho del rectángulo (coincide con el sprite)
        height = 64, -- Alto del rectángulo
        body = nil,
        shape = nil,
        fixture = nil,
        sprite = nil,
        distance = 35,
        stats = {
            hp = 100,
            curr_hp = 100,
            dmg = 1,
            speed = 200
        },
        angle = 0,
        hitboxX = 0,
        hitboxY = 0,
        hitting = false,
        fill = "line"
    }

    self.sprite = love.graphics.newImage("assets/sprites/pjtest.png")
    self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape((self.width / 2) * 0.5, self.height * 0.75)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    self.body:setFixedRotation(true)
    self.fixture:setUserData({
        type = "player",
        object = self
    })

    self.hitboxBody = love.physics.newBody(world, self.hitboxX, self.hitboxY, "kinematic") -- Kinematic para mover/rotar manualmente
    self.hitboxShape = love.physics.newRectangleShape((self.width / 2) * 0.5, self.height * 0.75)
    self.hitboxFixture = love.physics.newFixture(self.hitboxBody, self.hitboxShape, 1)
    self.hitboxFixture:setSensor(true)
    self.hitboxFixture:setUserData({
        type = "playerHitbox",
        object = self
    })

    world:setCallbacks(function(a, b, contact)
        local dataA, dataB = a:getUserData(), b:getUserData()
        if dataA and dataA.type == "playerHitbox" then
            dataA.object:beginContact(dataB or {
                type = "unknown"
            })
        elseif dataB and dataB.type == "playerHitbox" then
            dataB.object:beginContact(dataA or {
                type = "unknown"
            })
        end
    end, function(a, b, contact)
        local dataA, dataB = a:getUserData(), b:getUserData()
        if dataA and dataA.type == "playerHitbox" then
            dataA.object:endContact(dataB or {
                type = "unknown"
            })
        elseif dataB and dataB.type == "playerHitbox" then
            dataB.object:endContact(dataA or {
                type = "unknown"
            })
        end
    end)

    function self:beginContact(other)
        if self.hitting and other.type == "entity" and other.object then
            other.object.stats.curr_hp = other.object.stats.curr_hp - self.stats.dmg
            print("Hit entity: " .. (other.type or "unknown") .. ", HP: " .. other.object.stats.curr_hp)
            if other.object.stats.curr_hp <= 0 then
                print("Entity destroyed!")
                -- Aquí podrías marcar la entidad para eliminación (por ejemplo, other.object.destroyed = true)
            end
        end
    end

    function self:endContact(other)
        if other.type == "entity" then
            print("Stopped hitting: " .. (other.type or "unknown"))
        end
    end

    function self:update(dt, input, mouse)
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

        local mouseX, mouseY = mouse.x, mouse.y

        -- Calcular ángulo hacia el mouse
        self.angle = math.atan2(mouseY - self.y, mouseX - self.x)

        -- Calcular posición de la hitbox (orbita alrededor del jugador)
        self.hitboxX = self.x + math.cos(self.angle) * self.distance
        self.hitboxY = self.y + math.sin(self.angle) * self.distance

        -- Actualizar posición y ángulo de la hitbox
        self.hitboxBody:setPosition(self.hitboxX, self.hitboxY)
        self.hitboxBody:setAngle(self.angle)

        if mouse.isDown(1) then
            self.hitting = true
            self.fill = "fill"
        else
            self.hitting = false
            self.fill = "line"
        end
    end

    function self:draw()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
        -- Depuración: dibujar contorno del rectángulo físico y hitbox
        --   love.graphics.setColor(1, 0, 0) -- Rojo
        -- love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
        --  love.graphics.setColor(self.hitting and {1, 0, 0} or {0, 1, 0}) -- Rojo si activa, verde si no
        --  love.graphics.polygon(self.fill, self.hitboxBody:getWorldPoints(self.hitboxShape:getPoints()))
    end

    return self
end

return Player
