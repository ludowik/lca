class 'Fps' : extends(Window)

function Fps:init(x, y, w, h)
    self.appName = 'fps'
    
    x = x or 0
    y = y or 0
    
    w = w or safeArea.dy
    h = h or safeArea.dy
    
    Window.init(self, self, x, y, w, h)
end

function Fps:draw()
    background(0, 0, 0, 0)
    
    fontSize(self.size.h/2)
    
    textMode(CENTER)    
    text(love.timer.getFPS(), self.size.w/2, self.size.h/2)
end
