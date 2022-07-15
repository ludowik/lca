function Engine.keypressed(key, isrepeat)
end

function Engine.keyreleased(key)
    if key == 'escape' then
        quit()

    elseif key == 'r' then
        restart()

    elseif key == ',' then -- ?
        randomApp()

    elseif key == 'a' then
        loadApp('apps', 'apps')

    elseif key == 'i' then
        loadApp('apps', 'info')

    elseif key == 'l' then        
        appsList.saveCurrentIndex = 1 -- appsList.currentIndex
        loadApp('apps', 'apps').__autotest = true

    elseif key == 's' then
        scanTODO()

    elseif key == 't' then
        _G.env.__autotest = not _G.env.__autotest

    elseif key == 'j' then -- js
        makelovejs()
        makezip()

    elseif key == 'tab' then
        if isDown('lshift') then
            previousApp()
        else
            nextApp()
        end

    elseif key == 'w' then
        config.wireFrame = not config.wireFrame

    elseif key == 'f' then
        if config.framework == 'love2d' then
            config.framework = 'core'

        else
            config.framework = 'love2d'
        end
        restart()

    elseif key =='g' then
        if config.renderer == 'love2d' then
            config.renderer = 'core'

        elseif config.renderer == 'core' then
            config.renderer = 'soft'

        else
            config.renderer = 'love2d'
        end
        restart()

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

        position = vec2(),

        dx = 0,
        dy = 0,

        tx = 0,
        ty = 0,
    })

CurrentTouch = mouse

function mouseevent(state, x, y, button)
    x = x - X
    y = y - Y

    __mouseevent(state, x, y, button)
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
end

function Engine.mousepressed(x, y, button, istouch, presses)
    mouseevent(PRESSED, x, y, button, 0)

    if Rect(X, Y, W, H):contains(x, y) then
        local mouse2 = mouse
        if Engine.origin == BOTTOM_LEFT then
            mouse2 = mouse:clone()
            mouse2.y = H - mouse2.y
        end
        callApp('mousepressed', mouse2)
        callApp('touched', mouse2)
    end

    _G.env.parameter.touched(mouse)
end

function Engine.mousemoved(x, y, dx, dy, istouch)
    mouseevent(MOVED, x, y, mouse.button, 0)

    if Rect(X, Y, W, H):contains(x, y) then
        local mouse2 = mouse
        if Engine.origin == BOTTOM_LEFT then
            mouse2 = mouse:clone()
            mouse2.y = H - mouse2.y
        end
        callApp('mousemoved', mouse2)
        if istouch or love.mouse.isDown(mouse.button) then
            callApp('touched', mouse2)
        end
    end

    if istouch or love.mouse.isDown(mouse.button) then
        _G.env.parameter.touched(mouse)
    end
end

function Engine.mousereleased(x, y, button, istouch, presses)    
    mouseevent(RELEASED, x, y, button, presses)

    if Rect(X, Y, W, H):contains(x, y) then
        local mouse2 = mouse
        if Engine.origin == BOTTOM_LEFT then
            mouse2 = mouse:clone()
            mouse2.y = H - mouse2.y
        end
        callApp('mousereleased', mouse2)
        callApp('touched', mouse2)
    end

    _G.env.parameter.touched(mouse)
end

function Engine.wheelmoved(dx, dy)
    callApp('wheelmoved', dx, dy)
    _G.env.parameter.wheelmoved(dx, dy)
end

function Engine.buttondown(button)
end

function Engine.buttonup(button)
end
