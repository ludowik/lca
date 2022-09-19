class 'Slider' : extends(UI)

function Slider:init(variable, min, max, default, integer, callback)
    UI.init(self, variable, callback)

    self.min = min or 0
    self.max = max or 100

    self.default = default or 0
    
    self.value = default or 0

    self.integer = integer
    
    self.styles:attribs{
        bgColor = colors.green,
        textColor = colors.white,
    }
end

function Slider:computeSize()
    UI.computeSize(self)
    self.size.x = max(self.size.x, 100) 
end

function Slider:draw()
    UI.draw(self)
    
    local x = map(self.value, self.min, self.max, 0, self.size.x)
    stroke(colors.red)
    strokeSize(2)
    line(x, 0, x, self.size.y)   
    
    text(self.value, self.size.x, 0)
end

function Slider:setValue(value)
    self.__value = math.clamp(value, self.min, self.max)

    if self.integer then
        self.__value = round(self.__value)
    end

    if self.callback then
        self.callback(self, self.__value)
    end
end

function Slider:touched(touch)
    self:setValue(
        map(touch.x-self.absolutePosition.x,
            0, self.size.x,
            self.min, self.max))
end

function Slider:wheelmoved(dx, dy)
    self:setValue(self.value - (self.max - self.min) * dy / 10)
end
