-- MOUSE module

PRESSED = 'pressed'
BEGAN = PRESSED

MOVED = 'moved'
MOVING = MOVED

RELEASED = 'released'
ENDED = RELEASED

CANCELLED = 'cancelled'

STYLUS = 'stylus'

mouse = table(
    {
        state = MOVED,

        px = 0,
        py = 0,

        x = 0,
        y = 0,

        pos = vec2(),
        position = vec2(),

        dx = 0,
        dy = 0,

        tx = 0,
        ty = 0,

        altitude = 1,
        azimuthVec = vec2(),
    })
CurrentTouch = mouse

function mouseevent(state, x, y, button, presses)
    x = x - X
    y = y - Y

    __mouseevent(state, x, y, button, presses)
end

function __mouseevent(state, x, y, button, presses)
    mouse.id = 1

    mouse.state = state

    if state == PRESSED then
        mouse.sx = x
        mouse.sy = y

        mouse.px = x
        mouse.py = y

        mouse.tx = 0
        mouse.ty = 0
    else
        mouse.px = mouse.x
        mouse.py = mouse.y
    end

    mouse.x = x
    mouse.y = y

    mouse.pos:set(x, y)
    mouse.position:set(x, y)

    mouse.dx = mouse.x - mouse.px 
    mouse.dy = mouse.y - mouse.py

    mouse.tx = mouse.tx + mouse.dx
    mouse.ty = mouse.ty + mouse.dy

    if state == RELEASED then
        mouse.tapCount = presses
        if mouse.tapCount == 1 then
            if mouse.tx > 1 or mouse.ty > 1 then
                mouse.tapCount = 0
            end            
        end
    else
        mouse.tapCount = 0
    end

    mouse.button = button or mouse.button or 0

    -- CODEA
    mouse.deltaX = mouse.dx
    mouse.deltaY = mouse.dy

    mouse.pos = vec2(mouse.x, mouse.y)
    mouse.precisePos = mouse.pos

    -- pencil
    mouse.force = 1
    mouse.maxForce = 1
    mouse.altitude = 1
    mouse.azimuthVec = vec2()

    CurrentTouch = mouse
end

function __mouseReverseY(mouse)
    mouse = mouse:clone()
    mouse.y = H - mouse.y
    mouse.pos.y = mouse.y
    mouse.position.y = mouse.y
    mouse.dy = -mouse.dy
    mouse.deltaY = -mouse.deltaY
    return mouse
end

function __mouseScale(mouse, scale)
    mouse = mouse:clone()
    mouse.x = mouse.x * scale
    mouse.pos.x = mouse.x * scale
    mouse.position.x = mouse.x * scale
    mouse.dx = mouse.dx * scale
    mouse.deltaX = mouse.deltaX * scale
    mouse.y = mouse.y * scale
    mouse.pos.y = mouse.y * scale
    mouse.position.y = mouse.y * scale
    mouse.dy = mouse.dy * scale
    mouse.deltaY = mouse.deltaY * scale
    return mouse
end
