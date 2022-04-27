class 'Touch':extends(table)

function Touch.setup()
    Touch.touches = table()

    PRESSED = 'pressed'
    BEGAN = PRESSED

    MOVED = 'moved'
    MOVING = MOVED
    CHANGED = MOVED

    RELEASED = 'released'
    ENDED = RELEASED
    CANCELLED = RELEASED

    mouse = Touch()
    CurrentTouch = mouse
end

function Touch:init(id, state, x, y, dx, dy, pressure, button)
    self.tx = 0
    self.ty = 0

    self.sx = x or 0
    self.sy = y or 0

    self:set(id, state, x, y, dx, dy, pressure, button)
end

function Touch:set(id, state, x, y, dx, dy, pressure, button)
    self.id = id

    self.state = state

    self.x = x or 0
    self.y = y or 0

    self.dx = dx or 0
    self.dy = dy or 0

    self.delta = vec2(self.dx, self.dy)

    self.tx = self.tx + self.dx
    self.ty = self.ty + self.dy

    self.pressure = pressure
    self.button = button
end

function Touch:send()
    mouse = self:clone()
    CurrentTouch = mouse
    --    if app.win:contains(self) then
    --        app.win:touched(self)
    --    end

    for i = #WindowsManager.windows, 1, -1 do
        local window = WindowsManager.windows[i]
        if window.app and (window.app == _G.app or window.app == window) and window:contains(self) then
            window:touched(self)
        end
    end
end

if os.name == 'ios' then
    function love.touchpressed(id, x, y, dx, dy, pressure)
        Touch.touches[id] = Touch(id, PRESSED, x, y, dx, dy, pressure, button or id)
        Touch.touches[id]:send()

        local touches = love.touch.getTouches()
        if #touches == 3 then
            loadApp('apps/apps')
        elseif #touches == 4 then
            love.keyboard.setTextInput(true)
        end
    end

    function love.touchmoved(id, x, y, dx, dy, pressure)
        Touch.touches[id]:set(id, MOVED, x, y, dx, dy, pressure, id)
        Touch.touches[id]:send()
    end

    function love.touchreleased(id, x, y, dx, dy, pressure)
        Touch.touches[id]:set(id, RELEASED, x, y, dx, dy, pressure, id)
        Touch.touches[id]:send()

        Touch.touches[id] = nil
    end

else
    function love.mousepressed(x, y, button, istouch, presses)
        local id, dx, dy, pressure = 0, 0, 0, 1
        Touch.touches[id] = Touch(id, PRESSED, x, y, dx, dy, pressure, button or id)
        Touch.touches[id]:send()
    end

    function love.mousemoved(x, y, dx, dy, istouch)
        local id, pressure = 0, 1
        if Touch.touches[id] and love.mouse.isDown(Touch.touches[id].button) then
            Touch.touches[id]:set(id, MOVED, x, y, dx, dy, pressure, Touch.touches[id].button)
            Touch.touches[id]:send()
        end
    end

    function love.mousereleased(x, y, button, istouch, presses)
        local id, dx, dy, pressure = 0, 0, 0, 1
        Touch.touches[id]:set(id, RELEASED, x, y, dx, dy, pressure, button)
        Touch.touches[id]:send()

        Touch.touches[id] = nil
    end
end

function love.wheelmoved(x, y)
    if app.wheelmoved then
        app.wheelmoved(x, y)
    end
end

function isDown(key)
    return love.keyboard.isDown(key)
end

