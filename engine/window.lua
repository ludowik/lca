class 'WindowsManager'

function WindowsManager.setup()
    WindowsManager.windows = table()
end

function WindowsManager.update(dt)
    WindowsManager.windows:call('updateInstance', dt)
end

function WindowsManager.draw()
    love.graphics.setCanvas()
    love.graphics.reset()
    love.graphics.clear(0,0,0,1)

    WindowsManager.windows:call('drawInstance')
end

class 'Window'

function Window:init(env, x, y, w, h)
    x = db.get(env.app.name, 'x', x or 0)
    y = db.get(env.app.name, 'y', y or 0)

    w = w or (screen.w / 2)
    h = h or (screen.h / 2)

    WindowsManager.windows:insert(self)

    self.canvas = love.graphics.newCanvas(w, h)
    self.env = env
    self.styles = resetStyles()

    self.position = Rect(x, y, w, h)
end

function Window:contains(position)
    return self.position:contains(position.x, position.y)
end

function Window:setActive()
    self.styles = resetStyles()
    _G.styles = self.styles
    _G.env.W = self.position.w
    _G.env.H = self.position.h
end

function Window:updateInstance(dt)
    self:setActive()
    self:update(dt)
end

function Window:update(dt)
    if self.env ~= self then
        self.env:update(dt)
    end
end

function Window:drawInstance()
    love.graphics.setCanvas(self.canvas)
    do
        self:setActive()
        self:draw()
    end
    love.graphics.setCanvas()

    love.graphics.reset()
    love.graphics.draw(self.canvas, self.position.x, self.position.y)
end

function Window:draw()
    if self.env ~= self then
        self.env.draw()
    end
end

function Window:touchedWin(touch)
    if touch.state == PRESSED and touch.y < self.position.y + 25 then
        self.moving = true
    end

    if touch.state == MOVED and self.moving then
        self.position.x = self.position.x + touch.dx
        self.position.y = self.position.y + touch.dy
    end

    if touch.state == RELEASED then
        self.moving = false

        db.set(self.env.app.name, 'x', self.position.x)
        db.set(self.env.app.name, 'y', self.position.y)
    end
end

function Window:keyboard()
end
