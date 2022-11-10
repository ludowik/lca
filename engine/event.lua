function Engine.keypressed(key, isrepeat)
    local res = callApp('keyboard', key, isrepeat)

    key = (
        (isDown('lalt'  ) and 'lalt+'   or '')..
        (isDown('lctrl' ) and 'lctrl+'  or '')..
        (isDown('lshift') and 'lshift+' or '')..
        key
    )

    if Engine.keys[key] then
        Engine.keys[key].f()
    end
end

function Engine.keyreleased(key)
end

function Engine.touchpressed(id, x, y, dx, dy, pressure)
    Engine.mousepressed(x, y, id, true, 1)
end

function Engine.mousepressed(x, y, button, istouch, presses)
    mouseevent(PRESSED, x, y, button, 0)

    if Rect(X, Y, W, H):contains(x, y) then
        local mouse2 = __mouseScale(mouse, SCALE_APP)
        if getOrigin() == BOTTOM_LEFT then
            mouse2 = __mouseReverseY(mouse2)
            CurrentTouch = mouse2
        end
        callApp('mousepressed', mouse2)
        callApp('touched', mouse2)

    else
        if x < X then
            config.show.showLogs = not config.show.showLogs
        end
    end

    _G.env.parameter.touched(mouse)
end

function Engine.touchmoved(id, x, y, dx, dy, pressure)
    Engine.mousemoved(x, y, dx, dy, true)
end

function Engine.mousemoved(x, y, dx, dy, istouch)
    mouseevent(MOVED, x, y, mouse.button, 0)

    if Rect(X, Y, W, H):contains(x, y) then
        local mouse2 = __mouseScale(mouse, SCALE_APP)
        if getOrigin() == BOTTOM_LEFT then
            mouse2 = __mouseReverseY(mouse2)
            CurrentTouch = mouse2
        end
        callApp('mousemoved', mouse2)
        if istouch or love.mouse.isDown(mouse2.button) then
            if getCamera() then
                getCamera():processMouseMovement(__mouseReverseY(__mouseScale(mouse, SCALE_APP)), true)
            end

            callApp('touched', mouse2)
        end
    end

    if istouch or love.mouse.isDown(mouse.button) then
        _G.env.parameter.touched(mouse)
    end
end

function Engine.touchreleased(id, x, y, dx, dy, pressure)
    Engine.mousereleased(x, y, id, false, 1)
end

function Engine.mousereleased(x, y, button, istouch, presses)
    mouseevent(RELEASED, x, y, button, presses)

    if Rect(X, Y, W, H):contains(x, y) then
        local mouse2 = __mouseScale(mouse, SCALE_APP)
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

    if getCamera() then
        getCamera():processWheelMoveOnCamera({dx=dx, dy=dy})
    end
end

function Engine.buttondown(button)
end

function Engine.buttonup(button)
end

function Engine.captureImage(directory)
    local fileName
    if directory then
        fileName = directory..'/'.._G.env.appName..'_'..os.date('%Y%m%d_%H%M%S')..'.png'
    else
        directory = 'screenshots'
        fileName = directory..'/'.._G.env.appName..'.png'
    end
    love.filesystem.createDirectory(directory)
    _G.env.canvas:newImageData():encode('png', fileName)
end
