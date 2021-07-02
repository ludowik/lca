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

class 'Window'

function Window:init(env, x, y, w, h)
    w = w or 800
    h = h or 600

    WindowsManager.windows:insert(self)

    self.canvas = love.graphics.newCanvas(w, h)
    self.env = env
    self.styles = resetStyles()

    self.position = {
        x = x,
        y = y,
        w = w,
        h = h}
end

function Window:updateInstance(dt)
    self.styles = resetStyles()
    _G.styles = self.styles
    self:update(dt)
end

function Window:update(dt)
    env.update(dt)
end

function Window:drawInstance()
    self.canvas:renderTo(
        function ()
            self.styles = resetStyles()
            _G.styles = self.styles
            self:draw()
        end)
    love.graphics.reset()
    love.graphics.draw(self.canvas, self.position.x, self.position.y)
end

function Window:draw()
    env.draw()
end
