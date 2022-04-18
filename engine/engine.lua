if arg[#arg] == "-debug" then require("mobdebug").start() end

require 'lua.class'
require 'lua.math'
require 'lua.random'
require 'lua.string'

require 'graphics.window'
require 'graphics.transform'
require 'graphics.styles'
require 'graphics.color'
require 'graphics.graphics2d'

nilf = function() end 

setup = setup or nilf
update = update or nilf
draw = draw or nilf
keypressed = keypressed or nilf
mousepressed = mousepressed or nilf
mousemoved = mousemoved or nilf
mousereleased = mousereleased or nilf

os.name = love.system.getOS():lower():gsub(' ', '')

function makelove()
    if os.name ~= 'osx' then return end
    os.execute('makelove')
    os.execute('unzip -o makelove-build/lovejs/lca-lovejs.zip')
--    os.execute('python3 -m http.server 8080 --directory lca')
end

function love.load()
    makelove()

    setupClasses()
    setupWindow()

    setup()
end

function love.update(dt)
    update(dt)
end

function love.render(f)
    resetMatrix()
    resetStyles()
    
    f()
end

function love.draw()
    love.render(draw)
    love.render(function()
            text(love.timer.getFPS())
            text(windowSize)
            drawInfo()
        end)    
end

function love.keyreleased(key)
    if key == 'escape' then love.event.quit() end
end

function love.mousepressed()
    mousepressed()
end

function love.mousemoved()
    mousemoved()
end

function love.mousereleased()
    mousereleased()
end
