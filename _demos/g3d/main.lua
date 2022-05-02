-- written by groverbuger for g3d
-- september 2021
-- MIT license

local g3d = require "g3d"
local earth = g3d.newModel("assets/sphere.obj", "assets/earth.png", {4,0,0})
local moon = g3d.newModel("assets/sphere.obj", "assets/moon.png", {4,5,0}, nil, 0.5)
local background = g3d.newModel("assets/sphere.obj", "assets/starfield.png", nil, nil, 500)
local timer = 0

function love.update(dt)
    timer = timer + dt
    moon:setTranslation(math.cos(timer)*5 + 9, math.sin(timer)*5, 0)
    earth:setTranslation(math.cos(timer)*5 + 30, math.sin(timer)*5, 0)
    moon:setRotation(0, 0, timer - math.pi/2)
    g3d.camera.firstPersonMovement(dt)
    if love.keyboard.isDown "escape" then
        love.event.push "quit"
    end
end

local w, h = love.graphics.getDimensions()

local canvas
function love.draw()
    canvas = canvas or love.graphics.newCanvas(w, h)
    love.graphics.setCanvas({canvas, depth = true})
    love.graphics.clear()
    
    earth:draw()
    moon:draw()
    background:draw()
    
    love.graphics.setCanvas()
    love.graphics.draw(canvas)
end

function love.mousemoved(x,y, dx,dy)
    g3d.camera.firstPersonLook(dx,dy)
end
