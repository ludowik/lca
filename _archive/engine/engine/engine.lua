engine = interface()

function engine.load(arg, unfilteredArg)
end

function engine.update(dt)
    engine.app:update(dt)
end

function engine.draw()
    local app = engine.app

    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local rx, ry = w/app.size.w, h/app.size.h

    gx.reset()
    love.graphics.setCanvas(app.canvas)
    do
        engine.app:draw()
    end
    love.graphics.setCanvas()

    love.graphics.origin()
    love.graphics.draw(app.canvas, 0, h, 0, rx, -ry)

    love.graphics.translate(0, h)
    love.graphics.scale(rx, -ry)

    gx.fontSize(16)
    gx.stroke(red)

    gx.text(love.timer.getFPS(), w, h, RIGHT)
    gx.text(collectgarbage('count')*1024, w, nil, RIGHT)
end

function engine.keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    end
end

function engine.keyreleased(key, scancode, isrepeat)
end

function engine.mousemoved(x, y)
    local app = engine.app

    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    local rx, ry = w/app.size.w, h/app.size.h

    app:mouse(
        tointeger(x/rx),
        tointeger(y/ry))
end
