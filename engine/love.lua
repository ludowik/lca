local love2d = love

function love2d.load()
    love2d.makelove()

    local major, minor, revision, codename = love2d.getVersion()
    version = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)

    return Engine.load()
end

function love2d.makelove()
    local build_directory = "build"
    if os.name == 'osx' then
        os.execute('makelove')    
        os.execute('unzip -o '..build_directory..'/lovejs/lca-lovejs.zip -d '..build_directory..'/lovejs')
        os.execute('cp '..build_directory..'/lovejs/lca/game.data .')
    end
--    os.execute('python3 -m http.server 8080 --directory lca')
end

function love2d.update(dt)
    return Engine.update(dt)
end

function love2d.draw()
    return Engine.draw()
end

function love2d.keyreleased(...)
    return Engine.keyreleased(...)
end

function love2d.mousepressed(...)
    love.keyboard.setTextInput(true)
    return Engine.mousepressed(...)
end

function love2d.mousemoved(...)
    return Engine.mousemoved(...)
end

function love2d.mousereleased(...)
    return Engine.mousereleased(...)
end

function love.wheelmoved(x, y)
    return Engine.wheelmoved(x, y)
end

function isDown(key)
    return love.keyboard.isDown(key)
end

function getFPS()
    return love2d.timer.getFPS()
end

function quit(...)
    Engine.unload()
    return love2d.event.quit(...)
end

function exit()
    os.exit()
end

