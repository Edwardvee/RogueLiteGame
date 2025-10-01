local Slime = {}

function Slime.new(world, x, y)
    local self = {
        x = x or 400,
        y = y or 300,
        width = 32,
        height = 32,
        body = nil,
        shape = nil,
        fixture = nil,
        sprite = nil,
        aggroRadius = 300,
        stats = {
            hp = 30,
            curr_hp = 30,
            dmg = 1,
            speed = 50
        },
        isPlayerNearby = false,
        playerCoords = {
            x = 0,
            y = 0
        }
    }
    self.sprite = love.graphics.newImage("assets/sprites/slime.png")
    self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 100)
    self.body:setFixedRotation(true)
    self.fixture:setUserData({
        type = "slime",
        object = self
    })

    self.aggroBody = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.aggroShape = love.physics.newCircleShape(self.aggroRadius)
    self.aggroCircle = love.physics.newFixture(self.aggroBody, self.aggroShape)
    self.aggroCircle:setSensor(true)
    self.aggroCircle:setUserData({
        type = "sensor",
        object = self
    })

    world:setCallbacks(function(a, b, contact)
        local dataA, dataB = a:getUserData(), b:getUserData()
        if dataA and dataA.type == "sensor" then
            dataA.object:beginContact(dataB or {
                type = "unknown"
            })
        elseif dataB and dataB.type == "sensor" then
            dataB.object:beginContact(dataA or {
                type = "unknown"
            })
        end
    end, function(a, b, contact)
        local dataA, dataB = a:getUserData(), b:getUserData()
        if dataA and dataA.type == "sensor" then
            dataA.object:endContact(dataB or {
                type = "unknown"
            })
        elseif dataB and dataB.type == "sensor" then
            dataB.object:endContact(dataA or {
                type = "unknown"
            })
        end
    end)

    function self:beginContact(other)
        if other.type == "player" and other.object then
            self.isPlayerNearby = true
            print("Slime detecto al jugador en (" .. other.object.x .. ", " .. other.object.y .. ")")
        end
    end

    function self:endContact(other)
        if other.type == "player" then
            self.isPlayerNearby = false
            print("Slime perdio al jugador")
        end
    end
    function self:update(dt, player) -- Añadir player como parámetro para obtener coordenadas
        -- Actualizar posición del cuerpo principal
        self.x, self.y = self.body:getPosition()

        -- Sincronizar sensor con el cuerpo principal
        self.aggroBody:setPosition(self.x, self.y)

        -- Actualizar movimiento si el jugador está cerca
        if self.isPlayerNearby and player then
            -- Obtener coordenadas actuales del jugador
            self.playerCoords.x = player.x
            self.playerCoords.y = player.y

            -- Calcular dirección hacia el jugador
            local dx = self.playerCoords.x - self.x
            local dy = self.playerCoords.y - self.y
            local distance = math.sqrt(dx ^ 2 + dy ^ 2)

            -- Normalizar dirección y aplicar velocidad
            if distance > 0 then
                local vx = (dx / distance) * self.stats.speed
                local vy = (dy / distance) * self.stats.speed
                self.body:setLinearVelocity(vx, vy)
            else
                self.body:setLinearVelocity(0, 0)
            end
        else
            self.body:setLinearVelocity(0, 0)
        end
    end
    function self:draw()
        love.graphics.setDefaultFilter('nearest', 'nearest')

        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.sprite, self.x - self.width, self.y - self.height)

        -- Depuración
        love.graphics.setColor(1, 0, 0)
        love.graphics.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
        love.graphics.setColor(self.isPlayerNearby and {1, 0, 0} or {0, 1, 0})
        love.graphics.circle("line", self.x, self.y, self.aggroShape:getRadius())
    end
    return self

end
return Slime
