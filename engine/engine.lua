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

nilf = function() end 

setup = setup or nilf
update = update or nilf
draw = draw or nilf
keypressed = keypressed or nilf
mousepressed = mousepressed or nilf
mousemoved = mousemoved or nilf
mousereleased = mousereleased or nilf

class 'Engine'

function Engine.load()
    Engine.graphics = GraphicsTemplate()

    setupClasses()
    setupWindow()

    setup()
end

function Engine.update(dt)
    update(dt)
end

function Engine.render(f)
    resetMatrix()
    resetStyles()

    f()
end

function Engine.draw()
    Engine.render(draw)    
    Engine.render(function()
            text(getFPS())
            drawInfo()
        end)    
end

function Engine.keyreleased(key)
    if key == 'escape' then
        quit()
        
    elseif key == 'r' then
        quit('restart')
        
    elseif key =='g' then
        if point == GraphicsLove.point then
            Engine.graphics = GraphicsTemplate()
        else
            Engine.graphics = GraphicsLove()
        end
    end
end

function Engine.mousepressed()
    mousepressed()
end

function Engine.mousemoved()
    mousemoved()
end

function Engine.mousereleased()
    mousereleased()
end
