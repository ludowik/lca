function draw()
    background()

    resetMatrix()
    perspective()
    
    love.graphics.setDepthMode('always', true)
    
--    lookAt(vec3(10, 10, 10))
    
    local p = vec3(0, 0, 2)
--    print(matByVector(modelMatrix(), p))
--    print(matByVector(viewMatrix(), p))
    print(matByVector(pvmMatrix(), p))
    
--    quit()
--    isometric(20)
    
--    if elapsedTime/5 % 3 <= 1 then
--        rotate(elapsedTime, 1, 0, 0)
--    else
--        rotate(elapsedTime, 0, 1, 0)
--    end
    
    local w = 10
    --rect(0, 0, w, w)
    box(0, 0, -1, w, w, w)
end

function drawInfo()
    text(love.filesystem.getSaveDirectory())
    text(table.tolua(config))
    text(table.tolua({love.window.getSafeArea()}))
    text(table.tolua({mouse}))
end

PRESSED = 'pressed'
MOVED = 'moved'
RELEASED = 'released'

mouse = {
    state = MOVED,

    px = 0,
    py = 0,

    x = 0,
    y = 0,

    dx = 0,
    dy = 0,

    tx = 0,
    ty = 0,
}

-- TODO : => engine 
function mouseevent(state, x, y)
    mouse.state = state

    if state == PRESSED then
        mouse.px = x
        mouse.py = y
    else
        mouse.px = mouse.x
        mouse.py = mouse.y
    end

    mouse.x = x
    mouse.y = y

    mouse.dx = mouse.x - mouse.px 
    mouse.dy = mouse.y - mouse.py
end

function mousepressed(x, y)
    mouseevent(PRESSED, x, y)
end

function mousemoved(x, y)
    mouseevent(MOVED, x, y)    
end

function mousereleased(x, y)
    mouseevent(RELEASED, x, y)
end
