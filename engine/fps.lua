class 'Fps' : extends(Window)

function Fps:init(x, y)
    self.app = self
    self.name = 'fps'
    self:super(self, x, y, 50, 50)
end

function Fps:draw()
    background(0, 0, 0, 0)
    text(love.timer.getFPS())
    text(Touch.count)
end
