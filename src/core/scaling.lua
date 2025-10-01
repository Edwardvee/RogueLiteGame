-- src/core/scaling.lua
local Scaling = {}

function Scaling.new(baseWidth, baseHeight)
    local self = {
        baseWidth = baseWidth or 800, -- Resolución virtual
        baseHeight = baseHeight or 600,
        scaleX = 1,
        scaleY = 1
    }

    -- Actualizar factores de escala según la resolución actual
    function self:update()
        local windowWidth, windowHeight = love.graphics.getDimensions()
        self.scaleX = windowWidth / self.baseWidth
        self.scaleY = windowHeight / self.baseHeight
        -- Usar la escala más pequeña para mantener proporciones
        self.scale = math.min(self.scaleX, self.scaleY)
    end

    -- Aplicar transformación gráfica (para dibujar)
    function self:apply()
        love.graphics.push()
        love.graphics.scale(self.scale, self.scale)
        -- Opcional: centrar si hay barras negras
        local offsetX = (love.graphics.getWidth() - self.baseWidth * self.scale) / 2
        local offsetY = (love.graphics.getHeight() - self.baseHeight * self.scale) / 2
        love.graphics.translate(offsetX / self.scale, offsetY / self.scale)
    end

    -- Revertir transformación
    function self:pop()
        love.graphics.pop()
    end

    -- Convertir coordenadas de pantalla a coordenadas virtuales (para mouse)
    function self:toVirtualCoords(x, y)
        local offsetX = (love.graphics.getWidth() - self.baseWidth * self.scale) / 2
        local offsetY = (love.graphics.getHeight() - self.baseHeight * self.scale) / 2
        return (x - offsetX) / self.scale, (y - offsetY) / self.scale
    end

    self:update() -- Inicializar escala
    return self
end

return Scaling
