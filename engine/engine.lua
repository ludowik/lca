class 'Engine'

function Engine.load()
    Engine.graphics = config.renderer == 'core' and GraphicsCore() or GraphicsLove()

    deltaTime = 0
    elapsedTime = 0

    setupClasses()
    setupWindow()

    loadApps()

    if config.appName then
        loadApp(config.appName)
    else
        loadApp('info')
    end
end

function Engine.unload()
    saveConfig()
end

function Engine.update(dt)
    if Engine.test then
        Engine.test.delay = Engine.test.delay - dt
        if Engine.test.delay <=0 then
            nextApp()
            Engine.test.delay = 0.2
        end
    end

    deltaTime = dt
    elapsedTime = elapsedTime + dt

    callApp('update', dt)
end

function Engine.render(f, x, y)
    if not f then return end

    resetMatrix()
    resetStyles()

    if x then
        translate(x, y)
    end

    clip()

    f()
end

function Engine.beginDraw()
    if not _G.env.canvas then
        _G.env.canvas = love.graphics.newCanvas(W, H)
--        _G.env.depthBuffer = love.graphics.newCanvas(W, H, {format="depth24", readable=true})

        love.graphics.setCanvas({
                _G.env.canvas,
                depth = true,
            })

        love.graphics.clear(0, 0, 0, 1, true, true)
    end

    love.graphics.setCanvas({
            _G.env.canvas,
            depth = true,
        })

    love.graphics.setWireframe(config.wireFrame and true or false)
end

function Engine.endDraw(reverseY)
    love.graphics.setCanvas()
    love.graphics.origin()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setScissor()
    love.graphics.setBlendMode('replace')
    love.graphics.setWireframe(false)
    love.graphics.clear(.5, .5, .5, 1)

    local source
    if _G.env.imageData then
        source = love.graphics.newImage(_G.env.imageData)
    else
        source = _G.env.canvas
    end

    if reverseY then
        love.graphics.draw(source, X, H+Y, 0, 1, -1)
    else
        love.graphics.draw(source , X, Y)
    end
end

function Engine.draw()
    if _G.env.draw then
        Engine.beginDraw()
        do
            love.graphics.setDepthMode('always', true)
            Engine.render(_G.env.draw)
        end
        Engine.endDraw()
    end

    if _G.env.draw3d then
        Engine.beginDraw()
        do
            love.graphics.setMeshCullMode('back')
            love.graphics.setFrontFaceWinding('ccw')
            love.graphics.setDepthMode('lequal', true)
            love.graphics.clear()
            Engine.render(_G.env.draw3d)
        end
        Engine.endDraw(true)
    end

    love.graphics.setDepthMode('always', true)

    Engine.render(function()
            text(getFPS())
            text(elapsedTime)
            text(env.appName)
            text(config.renderer)
            callApp('drawInfo')
        end, X, Y)
end

function Engine.keyreleased(key)
    if key == 'escape' then
        quit()

    elseif key == 'r' then
        quit('restart')

    elseif key == ',' then -- ?
        randomApp()

    elseif key == 'l' then
        if Engine.test then
            Engine.test = nil
        else
            Engine.test = {delay=0}
        end

    elseif key == 't' then
        _G.env.autotest = not _G.env.autotest

    elseif key == 'tab' then
        if isDown('lctrl') then
            previousApp()
        else
            nextApp()
        end

    elseif key == 'w' then
        config.wireFrame = not config.wireFrame

    elseif key =='g' then
        _G.env.imageData = nil
        if point == GraphicsLove.point then
            config.renderer = 'core'
        else
            config.renderer = 'love'
        end

        Engine.graphics = config.renderer == 'core' and GraphicsCore() or GraphicsLove()
    else
        callApp('keyboard', key)

    end
end


-- MOUSE module

PRESSED = 'pressed'
MOVED = 'moved'
RELEASED = 'released'

mouse = {
    state = MOVED,

    px = 0,
    py = 0,

    x = 0,
    y = 0,

    dx = 0,
    dy = 0,

    tx = 0,
    ty = 0,
}

function mouseevent(state, x, y)
    mouse.state = state

    if state == PRESSED then
        mouse.px = x
        mouse.py = y
        mouse.sx = x
        mouse.sy = y
    else
        mouse.px = mouse.x
        mouse.py = mouse.y
    end

    mouse.x = x
    mouse.y = y

    mouse.dx = mouse.x - mouse.px 
    mouse.dy = mouse.y - mouse.py
end

local xBegin, yBegin
function Engine.mousepressed(x, y, button, istouch, presses)
    mouseevent(PRESSED, x, y)    
    xBegin, yBegin = x, y

    callApp('mousepressed', mouse)
end

function Engine.mousemoved(x, y, dx, dy, istouch)
    mouseevent(MOVED, x, y)

    callApp('mousemoved', mouse)
end

function Engine.mousereleased(x, y, button, istouch, presses)
    mouseevent(RELEASED, x, y)

    local xEnd, yEnd = x, y

    dx = abs(xEnd - xBegin)
    dy = abs(yEnd - yBegin)

    if xBegin > 0.85 * W and yBegin < 0.15 * H then
        quit()

    elseif xBegin > .5 * W and xEnd < .5 * W and dx > .4 * W and dy < .1 * dx then
        nextApp()

        -- TODO : slide function

    elseif xBegin < .5 * W and xEnd > .5 * W and dx > .4 * W and dy < .1 * dx then
        previousApp()

    else
        callApp('mousereleased', mouse)
        callApp('touched', mouse)
    end
end
