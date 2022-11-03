class 'Slider' : extends(UI)

function Slider:init(variable, min, max, default, integer, callback)
    UI.init(self, variable, callback)

    self.min = min or 0
    self.max = max or 100

    self.default = default or 0
    
    self.value = default or 0

    self.integer = integer
    
    self:setstyles{
        bgColor = colors.green,
        textColor = colors.white,
    }
end

function Slider:computeSize()
    UI.computeSize(self)
    
    local wval, hval = textSize(tostring(self.__value))
    local wmin, hmin = textSize(tostring(self.min))
    local wmax, hmax = textSize(tostring(self.max))
    local wdef, hdef = textSize(tostring(self.default))
    
    self.w = max(screenConfig.WT/10, self.size.x)
    
    self.size.x = self.w + max(wmin, wmax, wdef)
end

function Slider:draw()
    UI.draw(self)
    
    local x = map(self.value, self.min, self.max, 0, self.size.x)
    stroke(colors.red)
    strokeSize(2)
    line(x, 0, x, self.size.y)
    
    local formatValue = self:formatValue(self.__value)
    local w, h = textSize(formatValue)
    textMode(CORNER)
    text(formatValue, self.size.x-w, 0)
end

function Slider:formatValue(value)
    return tostring(round(value, 2))
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
