local __sign = math.sign

class 'ListBox' : extends(UI)

function ListBox:init(label, values, ...)
    UI.init(self)

    self.values = type(values) == 'table' and values or table()
    self.areas = table()

    self.action = callback(type(values) == 'function' and values or ...)

    self.dy = 0
end

function ListBox:list(values, i)
    self.values = values

    -- TOFIX : same code as ComboBox
    local value
    if i then
        value = values[i]
    else
        value = self:getValue()
    end

    if value == nil then
        value = values[1]
    end

--    self.uiValue:bind(self, 'value', value)

    if self.bind and values and i then
        self:setValue(values[i])
    end

    return self
end

function ListBox:computeSize()
    local wMax, hTot = 0, 0
    for i,item in ipairs(self.values) do
        local w, h = textSize(item)
        wMax = max(wMax, w)
        hTot = hTot + h
    end
    self.size.x, self.size.y = wMax, min(hTot, 200)
    self.hTot = hTot
end

function ListBox:draw()
    local position = self:getPosition()
    clip(position.x, position.y, self.size.x, self.size.y)

    self.needScrollBar = false

    self.areas:clear()

    local x, y = 0, 0

    textMode(CORNER)
    for i,value in ipairs(self.values) do
        local w, h = textSize(value)

        local position = vec2(position.x+x, position.y+y)
        if self:contains(position) then
            if value == self:getValue() then
                textColor(colors.green)
            else
                textColor(colors.white)
            end
            
            text(value, x, y)
            self.areas:add({value=value, rect=Rect(position.x, position.y, w, h)})
        else
            self.needScrollBar = true
        end

        y = y + h
    end

    noClip()
end

function ListBox:touched(touch)
    if touch.state == ENDED then
        if self:contains(touch) then
            for i,item in ipairs(self.areas) do
                if item.rect:contains(touch) then
                    self:setValue(item.value)
                    self:onSelectItem(i, item.value)
                    
                    self.action(item.item)
                end
            end
        end
    end
end

function ListBox:onSelectItem(i, value)
end

function ListBox:wheelmoved(dx, dy)
    local y = __sign(dy) * 10

    if self.needScrollBar then
        self.dy = self.dy - y

        self.dy = max(self.dy, 0)
        self.dy = min(self.dy, self.hTot - self.size.y)
    end
end
