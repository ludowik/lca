function love.info()
    local major, minor, revision, codename = love.getVersion()
    local version = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)
    print(version)

end

function love.load()
    love.info()
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

if os.name == 'ios' then 
    function love.touchpressed(...)
        return Engine.touchpressed(...)
    end

    function love.touchmoved(...)
        return Engine.touchmoved(...)
    end

    function love.touchreleased(...)
        return Engine.touchreleased(...)
    end

else
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
end
