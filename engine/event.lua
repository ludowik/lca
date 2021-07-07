class 'Touch'

function Touch.setup()
    Touch.touches = table()

    PRESSED = 'pressed'
    MOVED = 'moved'
    RELEASED = 'released'
end

function Touch:init(id, state, x, y, dx, dy, pressure, button)
    self.tx = 0
    self.ty = 0

    self:set(id, state, x, y, dx, dy, pressure, button)    
end

function Touch:set(id, state, x, y, dx, dy, pressure, button)
    self.id = id

    self.state = state

    self.x = x
    self.y = y

    self.dx = dx
    self.dy = dy

    self.tx = self.tx + dx
    self.ty = self.ty + dy 

    self.pressure = pressure
    self.button = button
end

function Touch:send()
    for i=#WindowsManager.windows,1,-1 do
        local window = WindowsManager.windows[i]
        if window:contains(self) then
            if window.env.touched then
                window.env.touched(self)
            end
        end
    end
end

if os.name == 'osx' then
    function love.touchpressed(id, x, y, dx, dy, pressure)
        Touch.touches[id] = Touch(id, PRESSED, x, y, dx, dy, pressure, id)
        Touch.touches[id]:send()
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
end

if os.name == 'osx' or os.name == 'windows' then
    function love.mousepressed(x, y, button, istouch, presses)
        id = 0
        Touch.touches[id] = Touch(id, PRESSED, x, y, 0, 0, 1, button)
        Touch.touches[id]:send()
    end

    function love.mousemoved(x, y, dx, dy, istouch)
        id = 0
        if Touch.touches[id] and love.mouse.isDown(Touch.touches[id].button) then
            Touch.touches[id]:set(id, MOVED, x, y, dx, dy, 1, Touch.touches[id].button)
            Touch.touches[id]:send()
        end
    end

    function love.mousereleased(x, y, button, istouch, presses)
        id = 0
        Touch.touches[id]:set(id, RELEASED, x, y, 0, 0, 1, button)
        Touch.touches[id]:send()

        Touch.touches[id] = nil
    end
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
        os.exit(0)
    elseif key == 'r' then
        love.event.quit('restart')
    else
        print(key)
        if love.keyboard.isDown('lalt') then
            if key ~= 'lalt' then
                if key == 'left' then
                    previousApp()
                elseif key == 'right' then
                    nextApp()
                else
                    env.keyboard('lctrl+'..key)
                end
            end
        else
            env.keyboard(key)
        end
    end
end
