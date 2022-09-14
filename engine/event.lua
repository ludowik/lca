function Engine.keypressed(key, isrepeat)
end

Engine.keys = {
    ['f1'] = {
        desc = 'Help',
        f = function ()
            openURL('https://codea.io/reference')
            openURL('https://love2d-community.github.io/love-api')
        end
    },

    ['escape'] = {
        desc = 'Quit',
        f = function ()
            quit()
        end
    },

    ['r'] = {
        desc = 'Restart',
        f = function ()
            restart()
        end
    },

    [','] = {
        desc = 'Random App',
        f = function () -- ?
            randomApp()
        end
    },

    ['a'] = {
        desc = 'Apps App',
        f = function ()
            loadApp('apps', 'apps')
        end
    },

    ['i'] = {
        desc = 'Info App',
        f = function ()
            loadApp('apps', 'info')
        end
    },

    ['t'] = {
        desc = 'Autotest App',
        f = function ()
            _G.env.__autotest = not _G.env.__autotest
        end
    },

    ['l'] = {
        desc = 'Autotest all Apps',
        f = function ()
            loadApp('apps', 'apps').__autotest = true
        end
    },

    ['m'] = {
        desc = 'Orientation',
        f = function ()
            if getMode() == PORTRAIT then
                setMode(LANDSCAPE)
            else
                setMode(PORTRAIT)
            end
        end
    },

    ['s'] = {
        desc = 'Scan toxxxx',
        f = function ()
            scanTODO()
        end
    },

    ['j'] = {
        desc = 'Generate lovejs',
        f = function () -- js
            makelovejs()
            makezip()
        end
    },

    ['tab'] = {
        desc = 'Navigate thru apps',
        f = function ()
            if isDown('lshift') then
                previousApp()
            else
                nextApp()
            end
        end
    },

    ['w'] = {
        desc = 'Wireframe',
        f = function ()
            config.wireFrame = not config.wireFrame
        end
    },

    ['f'] = {
        desc = 'Framework mode',
        f = function ()
            if config.framework == 'love2d' then
                config.framework = 'core'

            else
                config.framework = 'love2d'
            end
            restart()
        end
    },

    ['g'] = {
        desc = 'Graphics mode',
        f = function ()
            if config.renderer == 'love2d' then
                config.renderer = 'core'

            elseif config.renderer == 'core' then
                config.renderer = 'soft'

            else
                config.renderer = 'love2d'
            end
            restart()
        end
    },

    ['p'] = {
        desc = 'Capture Image',
        f = function ()
            Engine.captureImage()
        end
    },
}

function Engine.keyreleased(key)
    local res = callApp('keyboard', key)
    if res then return true end    
    if Engine.keys[key] then 
        Engine.keys[key].f()
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

STYLUS = 'stylus'

-- precisePos
-- force
-- maxForce

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

function Engine.mousepressed(x, y, button, istouch, presses)
    mouseevent(PRESSED, x, y, button, 0)

    if Rect(X, Y, W, H):contains(x, y) then
        local mouse2 = __mouseScale(mouse, SCALE)
        if getOrigin() == BOTTOM_LEFT then
            mouse2 = __mouseReverseY(mouse2)
            CurrentTouch = mouse2
        end
        callApp('mousepressed', mouse2)
        callApp('touched', mouse2)
    end

    _G.env.parameter.touched(mouse)
end

function Engine.mousemoved(x, y, dx, dy, istouch)
    mouseevent(MOVED, x, y, mouse.button, 0)

    if Rect(X, Y, W, H):contains(x, y) then
        local mouse2 = __mouseScale(mouse, SCALE)
        if getOrigin() == BOTTOM_LEFT then
            mouse2 = __mouseReverseY(mouse2)
            CurrentTouch = mouse2
        end
        callApp('mousemoved', mouse2)
        if istouch or love.mouse.isDown(mouse2.button) then
            if getCamera() then
                getCamera():processMouseMovement(mouse2, true)
            end

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
        local mouse2 = __mouseScale(mouse, SCALE)
        if getOrigin() == BOTTOM_LEFT then
            mouse2 = __mouseReverseY(mouse2)
            CurrentTouch = mouse2
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

function Engine.captureImage()
    _G.env.canvas:newImageData():encode('png', 'screenshots/'.._G.env.appName..'.png')
end
