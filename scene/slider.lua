class 'Slider' : extends(UI)

function Slider:init(variable, min, max, default, integer, callback)
    UI.init(self, variable, callback)

    self.value = default
    
    self.min = min
    self.max = max
    
    self.default = default
    
    self.integer = integer
end

function Slider:computeSize()
    UI.computeSize(self)
    self.size.x = max(self.size.x, 100) 
end

function Slider:draw()
    local x = map(self.value, self.min, self.max, 0, self.size.x)
    stroke(colors.red)
    strokeSize(2)
    line(x, 0, x, self.size.y)
    UI.draw(self)
end

function Slider:touched(touch)
    self.value = map(touch.x-self.position.x,
        0, self.size.x,
        self.min, self.max)

    if self.integer then
        self.value = round(self.value)
    end

    if self.callback then
        self.callback(self, self.value)
    end
end
