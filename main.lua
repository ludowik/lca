require 'engine.engine'

local angle
function setup()
    local major, minor, revision, codename = love.getVersion()
    version = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)
    
    angle = 0
end

function update(dt)
    angle = angle + dt
end

function draw()
    love.graphics.translate(W/2, H/2)
    love.graphics.rotate(angle)
    love.graphics.print(version)
end
