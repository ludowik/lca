class 'CheckBox' : extends(UI)

function CheckBox:init(label, value, callback)
    UI.init(self, label, callback)
    
    Bind.init(self, label, value, callback)
    self.value = value
    
    self:setstyles{
        textMode = CENTER,
        rx = 4,
    }
end

function CheckBox:touched(touch)
    if touch.state == RELEASED then
        self.value = not self.value

        if self.callback then
            self.callback(self, self.value)
        end
    end
end

function CheckBox:draw()
    if self.value then
        self:setstyles{textColor = colors.green}
    else
        self:setstyles{textColor = colors.red}
    end

    UI.draw(self)
end