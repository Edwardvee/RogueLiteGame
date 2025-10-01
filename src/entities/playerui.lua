local RayHit = {}

function RayHit.new(player, mouse)
    local self = {
        player = player,
        mouse = mouse,
        startX = 0,
        startY = 0,
        targetX = 0,
        targetY = 0
    }

    function self:update()
        self.startX = self.player.x
        self.startY = self.player.y
        self.targetX = self.mouse.x
        self.targetY = self.mouse.y
    end
    function self:draw()
        love.graphics.setColor(1, 0, 0)
        love.graphics.line(self.startX, self.startY, self.targetX, self.targetY)
    end
    return self
end

return RayHit
