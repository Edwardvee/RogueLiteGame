-- src/core/input.lua
local Input = {}

function Input.new()
    local self = {}

    local keys = {}

    -- Verifica si una tecla está presionada
    function self.isDown(key)
        return keys[key] or false
    end

    -- Actualiza el estado de las teclas
    function self:keypressed(key)
        keys[key] = true
    end

    function self:keyreleased(key)
        keys[key] = false
    end

    return self
end

return Input
