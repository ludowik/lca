class 'Separator' : extends(UI)

function Separator:init()
    UI.init(self, 'separator')
end

function Separator:computeSize()
    UI.computeSize(self)
    
    self.size.x = self.parent.size.x - self.size.x
    self.size.y = 3
end

function Separator:draw()
    strokeSize(1)
    stroke(colors.white)

    line(0, 1, self.size.x, 1)
end

class 'SeparatorNewLine' : extends(UI)

function SeparatorNewLine:init()
    UI.init(self, 'new line')
    self.newLine = true
end

function SeparatorNewLine:computeSize()
    self.size:set()
end

function SeparatorNewLine:draw()
end
