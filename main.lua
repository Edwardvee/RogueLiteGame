-- main.lua
local Player = require('src.entities.player')
local Input = require('src.core.input')
local Physics = require('src.core.physics')
local Rock = require('src.entities.blocks.rock')
local Mouse = require('src.core.mouse')
local RayHit = require('src.entities.playerui')
local HitDirection = require('src.entities.hitDirection')
local Cursor = require('src.entities.cursor')
local Scaling = require('src.core.scaling')
local Slime = require('src.entities.enemies.slime')
local scaling
local player
local input
local physics
local walls
local rocks
local mouse
local ray
local hitDirection
local cursor

local slime
function love.load()
    -- Inicializar módulos
    scaling = Scaling.new(800, 600) -- Resolución virtual
    input = Input.new()
    physics = Physics.new()
    player = Player.new(physics.world)
    mouse = Mouse.new()
    ray = RayHit.new(player, mouse)
    hitDirection = HitDirection.new(player, mouse)
    cursor = Cursor.new(mouse)

    -- Crear paredes estáticas (borde de la pantalla)
    walls = {
        top = physics:createStaticRect(400, 10, 800, 20),
        bottom = physics:createStaticRect(400, 590, 800, 20),
        left = physics:createStaticRect(10, 300, 20, 600),
        right = physics:createStaticRect(790, 300, 20, 600)
    }
    -- Crear objetos
    rocks = {
        rock1 = Rock.new(physics.world, 100, 400, 50, 50)
    }
    slime = Slime.new(physics.world, 100, 100)
    print("Input inicializado: ", type(input)) -- Depuración: verificar tipo de input
end

function love.update(dt)
    scaling:update()
    physics:update(dt)
    player:update(dt, input)
    mouse:updatePosition(love.mouse.getPosition())
    ray:update()
    hitDirection:update()
    cursor:update()
    slime:update(dt, player)
end

function love.draw()
    scaling:apply()
    player:draw()
    rocks.rock1:draw()
    mouse:hideSystemCursor()
    mouse:captureCursor()
    slime:draw()
    -- Dibujar paredes
    love.graphics.setColor(0.5, 0.5, 0.5) -- Gris
    for _, wall in pairs(walls) do
        love.graphics.polygon("fill", wall.body:getWorldPoints(wall.shape:getPoints()))
    end

    -- Depuración: mostrar estado de teclas en pantalla
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("W: " .. tostring(input.isDown('w')), 10, 10)
    love.graphics.print("A: " .. tostring(input.isDown('a')), 10, 30)
    love.graphics.print("S: " .. tostring(input.isDown('s')), 10, 50)
    love.graphics.print("D: " .. tostring(input.isDown('d')), 10, 70)

    -- ray:draw()

    hitDirection:draw()
    cursor:draw()
    scaling:pop()
end

function love.keypressed(key)
    input:keypressed(key)
    -- print("Tecla presionada: " .. key) -- Depuración
end

function love.keyreleased(key)
    input:keyreleased(key)
    -- print("Tecla liberada: " .. key) -- Depuración
end
function love.mousepressed(x, y, button)
    mouse:mousepressed(x, y, button)
    -- print("Mouse presionado: boton " .. button .. " en (" .. x .. ", " .. y .. ")")
end

function love.mousereleased(x, y, button)
    mouse:mousereleased(x, y, button)
    -- print("Mouse liberado: boton " .. button .. " en (" .. x .. ", " .. y .. ")")
end
function love.mousemoved(x, y, dx, dy)
    -- print("Mouse:  (" .. x .. ", " .. y .. ")")

end
