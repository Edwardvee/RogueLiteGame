local Physics = {}

function Physics.new()
    local self = {}
    self.world = love.physics.newWorld(0, 0, true) -- Creo el mundo sin gravedad

    function self:update(dt)
        self.world:update(dt)
    end
    function self:createStaticRect(x, y, width, height)
        local body = love.physics.newBody(self.world, x, y, "static")
        local shape = love.physics.newRectangleShape(width, height)
        local fixture = love.physics.newFixture(body, shape, 1)
        return {
            body = body,
            shape = shape,
            fixture = fixture
        }
    end
    return self
end

return Physics
