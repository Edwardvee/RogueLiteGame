local Cursor = {}

function Cursor.new(mouse)
    local self = {
        mouse = mouse,
        x = 0,
        y = 0
    }
    self.sprite = love.graphics.newImage("assets/sprites/hitCursor.png")
    function self:update()
        self.x = self.mouse.x
        self.y = self.mouse.y
    end
    function self:draw()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.sprite, self.x, self.y, 0, 1, 1)
    end
    return self
end

return Cursor
