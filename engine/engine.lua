if arg[#arg] == "-debug" then require("mobdebug").start() end

require 'lua.os'
require 'lua.class'
require 'lua.math'
require 'lua.random'
require 'lua.string'
require 'lua.vec2'
require 'lua.vec3'
require 'lua.vec4'
require 'lua.table'

require 'graphics.window'
require 'graphics.transform'
require 'graphics.styles'
require 'graphics.color'
require 'graphics.graphics2d'
require 'graphics.graphics2d_love'

require 'engine.app'
require 'engine.love'
require 'engine.config'

class 'Engine'

function Engine.load()
    Engine.graphics = GraphicsLove() -- config.renderer == 'love' and GraphicsLove() or GraphicsTemplate()

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

    callApp('setup')
end

function Engine.unload()
    saveConfig()
end

function Engine.update(dt)
    if Engine.test then
        Engine.test.delay = Engine.test.delay - dt
        if Engine.test.delay <=0 then
            randomApp()
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
        _G.env.depthBuffer = love.graphics.newCanvas(W, H, {format="depth24", readable=true})
        love.graphics.setCanvas({
                _G.env.canvas,
                depth = true,
--                depthstencil = _G.env.depthBuffer
            })
        love.graphics.clear() -- 0, 0, 0, 1, true, true)
    end

    love.graphics.setCanvas({
            _G.env.canvas,
            depth = true,
--            depthstencil = _G.env.depthBuffer
        })

--    love.graphics.setWireframe(config.wireFrame and true or false)
end

function Engine.endDraw(reverseY)
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setScissor()
    
    love.graphics.setBlendMode('replace')
    love.graphics.origin()
    love.graphics.setWireframe(false)

    if reverseY then
        love.graphics.draw(_G.env.canvas, X, H-Y, 0, 1, -1)
    else
        love.graphics.draw(_G.env.canvas, X, Y)
    end
end

function Engine.draw()
    if _G.env.draw then
        Engine.beginDraw()

        love.graphics.setDepthMode('always', true)

        Engine.render(_G.env.draw)

        Engine.endDraw()
    end

    if _G.env.draw3d then
        Engine.beginDraw()

        love.graphics.setMeshCullMode('back')
        love.graphics.setFrontFaceWinding('ccw')
        love.graphics.setDepthMode('lequal', true)
        love.graphics.clear(0, 0, 0, 1, true, true)

        Engine.render(_G.env.draw3d)

        Engine.endDraw(true)
    end

    love.graphics.setDepthMode('always', true)

    Engine.render(function()
            text(getFPS())
            text(elapsedTime)
            text(apps.listByIndex[apps.current].name)
            callApp('drawInfo')
        end, X, Y)
end

function Engine.keyreleased(key)
    if key == 'escape' then
        quit()

    elseif key == 'r' then
        quit('restart')

    elseif key == 'tab' then
        randomApp()

    elseif key == 't' then
        if Engine.test then
            Engine.test = nil
        else
            Engine.test = {delay=0}
        end

    elseif key == 'left' then
        previousApp()

    elseif key == 'right' then
        nextApp()

    elseif key == 'w' then
        config.wireFrame = not config.wireFrame

    elseif key =='g' then
        if point == GraphicsLove.point then
            Engine.graphics = GraphicsTemplate()
        else
            Engine.graphics = GraphicsLove()
        end
    end
end

local xBegin, yBegin
function Engine.mousepressed(x, y, button, istouch, presses)
    xBegin, yBegin = x, y
    callApp('mousepressed', x, y, button, istouch, presses)
end

function Engine.mousemoved(x, y, dx, dy, istouch)
    callApp('mousemoved', x, y, dx, dy, istouch)
end

function Engine.mousereleased(x, y, button, istouch, presses)
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
        callApp('mousereleased', x, y, button, istouch, presses)
    end
end
