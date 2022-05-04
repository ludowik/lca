class 'WindowsManager'

function WindowsManager.setup()
    WindowsManager.windows = table()
end

function WindowsManager.update(dt)
    WindowsManager.windows:call('updateInstance', dt)
end

function WindowsManager.draw()
    WindowsManager.windows:call('drawInstance')
end

class 'Window' : extends(Rect)

function Window.setup()
    TOP_LEFT = 'top_left'
    BOTTOM_LEFT = 'bottom_left'
end

function setOrigin(origin)
    if win then
        win.origin = origin
    end
end

function getOrigin()
    if win and win.origin then
        return win.origin
    end
    return TOP_LEFT
end

function Window:init(app, x, y, w, h, scale)
    local ratio = 9/10
    x = x or (screen.w - safeArea.w*ratio) / 2 -- db.get(app.appName, 'x', x or safeArea.dx)
    y = y or (screen.h - safeArea.h*ratio) / 3 -- db.get(app.appName, 'y', y or safeArea.dy)

    w = w or (safeArea.w*ratio)
    h = h or (safeArea.h*ratio)

    self.scale = scale or 1

    WindowsManager.windows:insert(self)

    self.img = image(w*self.scale, h*self.scale)
    self.app = app

    self:resetStyle()

    Rect.init(self, x, y, w, h)

    self.origin = TOP_LEFT
end

function Window:resetStyle()
    self.styles = table{
        fontName = 'Arial',
        fontSize = 14,

        textMode = CORNER,
        textWrapWidth = -1,
        textAlign = LEFT,

        stroke = white,
        strokeWidth = 1,

        fill = white,

        rectMode = CORNER,
        circleMode = CENTER,
        ellipseMode = CENTER,
        spriteMode = CORNER,

        yText = 0
    }
    _G.styles = self.styles
end

function Window:setupInstance()
    self:setActive()
    if self.app ~= self then
        self.app:setup()
    end
end

function Window:setActive()
    self:resetStyle()

    _G.win = self

    _G.app.W = self.size.w
    _G.app.H = self.size.h

    _G.app.WIDTH = self.size.w
    _G.app.HEIGHT = self.size.h

    W, H = _G.app.W, _G.app.H
end

function Window:updateInstance(dt)
    self:setActive()
    TweensManager.update(dt)
    self:update(dt)
    Application.updateCoroutine(self.app, dt)
end

function Window:update(dt)
    if self.app ~= self then
        self.app.physics.update(dt)
        self.app.update(dt)
    end
end

function Window:drawInstance(canvas, x, y, ratio)
    love.graphics.reset()
    love.graphics.setCanvas(self.img.canvas)
--    love.graphics.clear(0, 0, 0, 1)

    do
        self:setActive()
        resetMatrix(true)

        self:draw()

        if self.app.parameter then
            self.app.parameter.draw()
        end
    end
    love.graphics.setCanvas() -- canvas
    love.graphics.reset()

    x = x or self.position.x
    y = y or self.position.y

    local w = self.size.w
    local h = self.size.h

    ratio = ratio or 1/self.scale
    if self.origin == BOTTOM_LEFT then
        love.graphics.draw(self.img.canvas, x, y + h, 0, ratio, -ratio)
    else
        love.graphics.draw(self.img.canvas, x, y, 0, ratio, ratio)
    end

    love.graphics.rectangle('line', x, y, w, h)
end

function Window:draw()
    if self.app ~= self then
        self.app.draw()
    elseif self.scene then
        self.scene:draw()
    end
end

function Window:touched(touch)
    touch = touch:clone()

    touch.x = touch.x - self.position.x
    touch.y = touch.y - self.position.y

    touch.x = touch.x * self.scale
    touch.y = touch.y * self.scale

    if self.origin == BOTTOM_LEFT then
        touch.y = self.size.h - touch.y
    end

    if self.app.parameter then
        self.app.parameter.touched(touch)
    end

    if self.app and self.app ~= self then
        self.app.touched(touch)

    elseif self.scene and self.scene ~= self then
        self.scene:touched(touch)
    end

    self:moveWindow(touch)
end

function Window:moveWindow(touch)
    if movingWindow == nil and touch.state == PRESSED and touch.y < 25 then
        movingWindow = self

    elseif movingWindow == self and touch.state == MOVED then
        self.position.x = self.position.x + touch.dx
        self.position.y = self.position.y + touch.dy

        db.set(self.app.appName, 'x', self.position.x)
        db.set(self.app.appName, 'y', self.position.y)

    elseif touch.state == RELEASED then
        movingWindow = nil
    end
end

function Window:keyboard()
end

class 'Widget' : extends(Window)

function Widget:init(callback)
    self.appName = 'widget'
    self.callback = callback
    self.active = true
    Window.init(self, self, screen.w-100, screen.h-100, 100, 100)
    self.scene = Scene()
end

--function Widget:touched(touch)
--    if self.callback then
--        self.callback()
--    end
--end
