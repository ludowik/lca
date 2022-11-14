class 'CheckBox' : extends(UI)

function CheckBox:init(label, value, callback)
    UI.init(self, label, callback)
    
    Bind.init(self, label, value, callback)
    
    self:setValue(value)
    
    self:setstyles{
        textMode = CENTER,
        rx = 4,
    }
end

function CheckBox:touched(touch)
    if touch.state == RELEASED then
        self:setValue(not self:getValue())

        if self.callback then
            self.callback(self, self:getValue())
        end
    end
end

function CheckBox:draw()
    if self:getValue() then
        self:setstyles{textColor = colors.green}
    else
        self:setstyles{textColor = colors.red}
    end

    UI.draw(self)
end
