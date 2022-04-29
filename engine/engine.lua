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
        love.graphics.setCanvas(_G.env.canvas)
        love.graphics.clear(0, 0, 0, 1)
    end
    love.graphics.setCanvas(_G.env.canvas)
end

function Engine.endDraw()
    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setScissor()
    love.graphics.setBlendMode('replace')
    love.graphics.origin()
    love.graphics.draw(_G.env.canvas, X, Y)
end

function Engine.draw()
    Engine.beginDraw()
    Engine.render(_G.env.draw)
    Engine.endDraw()    

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
