function draw()
    background()

    rectMode(CENTER)
--    translate(W/2, H/2)
--    translate(0, 0, -200)

    perspective()
    lookAt(vec3(0, 0, -10))

    local w = 1
    fill(colors.red)
    box(0, 0, 0, w, w, w)
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
