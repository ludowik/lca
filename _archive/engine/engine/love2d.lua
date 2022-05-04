function love.load(...)
    love.window.setMode(800, 600, {
            resizable = true
        })

    return engine.load(...)
end

function love.update(...)
    engine.update(...)
end

function love.draw(...)
    engine.draw(...)
end

function love.keypressed(...)
    engine.keypressed(...)
end

function love.keyreleased(...)
    engine.keyreleased(...)
end

function love.mousemoved(x, y, dx, dy, istouch)
    engine.mousemoved(x, y)
end
