Slider = class 'slider' : extends(UI)

function Slider:init(var, min, max, default)
    UI.init(self, var)
    
    self.min = min or 0
    self.max = max or 100
    
    self.var = var or self.min
    
    self.value = evalExpression(self.var) or default 
    setValue(self.var, self.value)
    
    math.clamp(self.value, self.min, self.max)
    
    self.size.w = 200
end

function Slider:getLabel()
    local value = tostring(evalExpression(self.var) or self.var or 'nil')
    return tostring(value)
end

function Slider:draw()
    UI.draw(self)
end

function Slider:touched(touch)
    local pos = vec2(touch.x, touch.y) - (self.position - self.size/2)
    local pct = pos.x / self.size.w
    local value = self.min + pct * (self.max - self.min)
    
    setValue(self.var, value)
end
