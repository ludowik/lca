--os.name = 'ios'
--os.simulator = true

require 'engine'

--APPS = 'apps_archive'
APPS = 'apps'

function love.setup()
    love.window.setMode(W, H)
end

function love.draw()
    text('hello', W/2, H/2)
end
