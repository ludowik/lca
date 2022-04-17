require 'engine.engine'

local angle
function setup()
    angle = 0
end

function update(dt)
    angle = angle + dt
end

function draw()
    love.graphics.translate(W/2, H/2)
    love.graphics.rotate(angle)
    love.graphics.print('hello world')
end
