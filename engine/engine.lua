nilf = function() end 

setup = setup or nilf
update = update or nilf
draw = draw or nilf

function love.load()
    W, H = love.graphics.getDimensions()
    setup()
end

function love.update(dt)
    update(dt)
end

function love.draw()
    draw()
end

function love.keyreleased(key)
    if key == 'escape' then love.event.quit() end
end
