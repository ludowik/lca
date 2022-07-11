class 'Separator' : extends(UI)

function Separator:init()
    UI.init(self, 'line')
end

function Separator:computeSize()
    UI.computeSize(self)
    
    self.size.x = self.parent.size.x - self.size.x
    self.size.y = 3
end

function Separator:draw()
    strokeSize(1)
    stroke(white)

    line(0, 1, self.size.x, 1)
end
