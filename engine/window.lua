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
    x = x or 0
    y = y or 0

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
    function render()
        self:setActive()
        self:draw()
    end

    love.graphics.setCanvas(self.canvas)
    render()
    love.graphics.setCanvas()

    love.graphics.reset()
    love.graphics.draw(self.canvas, self.position.x, self.position.y)
end

function Window:draw()
    if self.env ~= self then
        self.env.draw()
    end
end

function Window:touched(touch)
end

function Window:keyboard()
end
