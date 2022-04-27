function setupComponents()
    for k, v in pairs(_G) do
        if (type(v) == 'table') then if v.setup then v.setup() end end
    end
end

function love.load()
    pixelSize = 4
    W, H = love.graphics.getDimensions()
    W = W / pixelSize
    H = H / pixelSize
    elapsedTime = 0

    screen = {W = W, H = H}

    setupComponents()
end

function love.keyreleased(key)
    if key == 'escape' then love.event.quit() end
    if key == 'p' then usePtr = not usePtr end
    keypressed(key)
end

function love.draw()
    deltaTime = love.timer.getDelta()
    elapsedTime = elapsedTime + deltaTime

    beginDraw()
    do
        update(deltaTime)

        resetMatrix(true)
        ortho()

        draw()
    end
    endDraw()

    love.graphics.print(love.timer.getFPS())
end
