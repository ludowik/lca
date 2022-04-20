if arg[#arg] == "-debug" then require("mobdebug").start() end

require 'lua.os'
require 'lua.class'
require 'lua.math'
require 'lua.random'
require 'lua.string'

require 'graphics.window'
require 'graphics.transform'
require 'graphics.styles'
require 'graphics.color'
require 'graphics.graphics2d'
require 'graphics.graphics2d_love'

require 'engine.love'

class 'Engine'

function call(fname, ...)
    if _G.env and _G.env[fname] then 
        return _G.env[fname](...)
    end
end

function Engine.load()
    Engine.graphics = GraphicsLove()
    
    deltaTime = 0
    ellapsedTime = 0

    setupClasses()
    setupWindow()

    call('setup')
end

function Engine.update(dt)
    deltaTime = dt
    ellapsedTime = ellapsedTime + dt
    
    call('update', dt)
end

function Engine.render(f)
    if not f then return end
    
    resetMatrix()
    resetStyles()
    
    f()
end

function Engine.draw()
    Engine.render(_G.env.draw)
    Engine.render(function()
            text(getFPS())
            call('drawInfo')
        end)
end

function Engine.keyreleased(key)
    if key == 'escape' then
        quit()
        
    elseif key == 'r' then
        quit('restart')
        
    elseif key == 't' then
        nextApp()
        
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

function Engine.mousepressed(...)
    call('mousepressed', ...)
end

function Engine.mousemoved(...)
    call('mousemoved', ...)
end

function Engine.mousereleased(...)
    call('mousereleased', ...)
end
