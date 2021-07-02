class 'Fps' : extends(Window)

function Fps:init()
    self:super(self, 0, 0, 50, 50)
end

function Fps:draw()
    background(0.5, 0.5, 0.5)
    text(love.timer.getFPS())
end
