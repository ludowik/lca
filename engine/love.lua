function love.info()
    local major, minor, revision, codename = love.getVersion()
    version = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)
end

function love.load()
    return Engine.load()
end

function love.update(dt)
    return Engine.update(dt)
end

function love.draw()
    return Engine.draw()
end

function love.keypressed(key, scancode, isrepeat)
    return Engine.keypressed(key, isrepeat)
end

function love.keyreleased(key, scancode)
    return Engine.keyreleased(key)
end

function love.mousepressed(...)
    return Engine.mousepressed(...)
end

function love.mousemoved(...)
    return Engine.mousemoved(...)
end

function love.mousereleased(...)
    return Engine.mousereleased(...)
end

function love.wheelmoved(dx, dy)
    return Engine.wheelmoved(dx, dy)
end
