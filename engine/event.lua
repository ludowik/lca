function Engine.keyreleased(key)
    if key == 'escape' then
        quit()

    elseif key == 'r' then
        quit('restart')

    elseif key == ',' then -- ?
        randomApp()

    elseif key == 'l' then
        if Engine.test then
            Engine.test = nil
        else
            Engine.test = {
                index=1,
                delay=0
            }
        end

    elseif key == 't' then
        _G.env.autotest = not _G.env.autotest

    elseif key == 'tab' then
        if isDown('lctrl') then
            previousApp()
        else
            nextApp()
        end

    elseif key == 'w' then
        config.wireFrame = not config.wireFrame

    elseif key =='g' then
        _G.env.imageData = nil
        if point == GraphicsLove.point then
            config.renderer = 'core'
        else
            config.renderer = 'love'
        end

        Engine.graphics = config.renderer == 'core' and GraphicsCore() or GraphicsLove()
    else
        callApp('keyboard', key)

    end
end


-- MOUSE module

PRESSED = 'pressed'
BEGAN = PRESSED

MOVED = 'moved'
MOVING = MOVED

RELEASED = 'released'
ENDED = RELEASED

CANCELLED = 'cancelled'

mouse = table({
        state = MOVED,

        px = 0,
        py = 0,

        x = 0,
        y = 0,

        dx = 0,
        dy = 0,

        tx = 0,
        ty = 0,
    })

CurrentTouch = mouse

function mouseevent(state, x, y, button)
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

    mouse.dx = mouse.x - mouse.px 
    mouse.dy = mouse.y - mouse.py

    mouse.tx = mouse.tx + mouse.dx
    mouse.ty = mouse.ty + mouse.dy

    mouse.button = button or mouse.button or 0
end

local xBegin, yBegin
function Engine.mousepressed(x, y, button, istouch, presses)
    mouseevent(PRESSED, x, y, button)    
    xBegin, yBegin = x, y

    callApp('mousepressed', mouse)
    callApp('touched', mouse)

    _G.env.parameter.touched(mouse)
end

function Engine.mousemoved(x, y, dx, dy, istouch)
    mouseevent(MOVED, x, y)

    callApp('mousemoved', mouse)
    if istouch or love.mouse.isDown(mouse.button) then
        callApp('touched', mouse)
    end
end

function Engine.mousereleased(x, y, button, istouch, presses)
    mouseevent(RELEASED, x, y)

    local xEnd, yEnd = x, y

    dx = abs(xEnd - xBegin)
    dy = abs(yEnd - yBegin)

    if xBegin > 0.85 * W and yBegin < 0.15 * H then
        quit()

    elseif xBegin > .5 * W and xEnd < .5 * W and dx > .4 * W and dy < .1 * dx then
        nextApp()

        -- TODO : slide function

    elseif xBegin < .5 * W and xEnd > .5 * W and dx > .4 * W and dy < .1 * dx then
        previousApp()

    else
        callApp('mousereleased', mouse)
        callApp('touched', mouse)
    end
end
