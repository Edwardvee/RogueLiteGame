-- main.lua
local Player = require('src.entities.player')
local Input = require('src.core.input')

local player
local input

function love.load()
    -- Inicializar módulos
    input = Input.new()
    player = Player.new()
    print("Input inicializado: ", type(input)) -- Depuración: verificar tipo de input
end

function love.update(dt)
    player:update(dt, input)
end

function love.draw()
    player:draw()
    -- Depuración: mostrar estado de teclas en pantalla
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("W: " .. tostring(input.isDown('w')), 10, 10)
    love.graphics.print("A: " .. tostring(input.isDown('a')), 10, 30)
    love.graphics.print("S: " .. tostring(input.isDown('s')), 10, 50)
    love.graphics.print("D: " .. tostring(input.isDown('d')), 10, 70)
end

function love.keypressed(key)
    input:keypressed(key)
    print("Tecla presionada: " .. key) -- Depuración
end

function love.keyreleased(key)
    input:keyreleased(key)
    print("Tecla liberada: " .. key) -- Depuración
end
