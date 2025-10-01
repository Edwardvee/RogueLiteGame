local Mouse = {}
function Mouse.new()
    local self = {}
    self.x = 0
    self.y = 0
    local buttons = {}
    function self.isDown(button)
        return buttons[button] or false
    end
    function self:updatePosition(x, y)
        self.x = x
        self.y = y
    end
    function self:mousepressed(x, y, button)
        buttons[button] = true
        self:updatePosition(x, y)
    end
    function self:mousereleased(x, y, button)
        buttons[button] = false
        self:updatePosition(x, y)
    end
    function self:hideSystemCursor()
        love.mouse.setVisible(false)
    end

    function self:captureCursor()
        love.mouse.setGrabbed(true)
        local screenWidth, screenHeight = love.graphics.getDimensions()
    end
    return self
end

return Mouse
