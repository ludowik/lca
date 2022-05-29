--local http = require 'https'
--local response = http.send('https://ludowik.github.io/lca/build/love/lca.love')
--print(response.code, response.body)
--love.filesystem.write('lca.love', response.body)
--love.filesystem.mount('lca.love', '', false)

--local http = require 'socket.http'
--local response = http.request('http://ludowik.github.io/lca/build/love/lca.love')
--print(response)

if false then
    function love.setup()
        love.window.setMode(100, 200, {
                highdpi = true,
                usedpiscale = true
            })

    end

    function love.draw()
        local w, h = love.window.getMode()
        w, h = love.graphics.getDimensions()

        local x, y = love.mouse.getPosition()

        love.graphics.print(w..','..h, 10, 100)
        love.graphics.print(x..','..y, 10, 125)
        love.graphics.print(love.window.getDPIScale(), 10, 150)

        love.graphics.line(0, 0, 300, 300)
    end

    function love.keypressed(key)
        if key == 'escape' then love.event.quit() end
    end
    
else
    love.filesystem.setRequirePath(love.filesystem.getRequirePath()..';?/__init.lua')
    print(love.filesystem.getRequirePath())

    require 'engine'
end
