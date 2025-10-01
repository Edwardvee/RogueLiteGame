local Rock = {}

function Rock.new(world, x, y, width, height)
    local self = {
        x = x,
        y = y,
        width = width,
        height = height,
        body = nil,
        shape = nil,
        fixture = nil
    }
    self.body = love.physics.newBody(world, self.x, self.y, "static")
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape, 1)
    function self:draw()
        love.graphics.setColor(0, 1, 0)
        love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)

    end
    return self
end

return Rock
