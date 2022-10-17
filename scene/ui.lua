class 'UI' : extends(Rect, Bind)

function UI:init(label, callback)
    Rect.init(self)

    self.label = label or ''
    self.callback = callback

    self.styles = table({
            fontName = DEFAULT_FONT_NAME,
            fontSize = DEFAULT_FONT_SIZE,
            bgColor = colors.lightgray,
            textMode = CORNER,
        })

    self.marge = vec2(6, 0)

    self.visible = true
end

function UI.properties.set:value(value)
    self:setValue(value)
end

function UI.properties.get:value()
    return self:getValue()
end

function UI:setstyles(...)
    self.styles:attribs(...)
    return self
end

function UI:computeSize()
    fontName(self.styles.fontName or DEFAULT_FONT_NAME)
    fontSize(self.styles.fontSize or DEFAULT_FONT_SIZE)

    self.size:set(textSize(self:getLabel()))

    self.size.x = max(self.size.x, DEFAULT_FONT_SIZE) + self.marge.x * 2
    self.size.y = max(self.size.y, DEFAULT_FONT_SIZE) + self.marge.y * 2
end

function UI:getLabel()
    return tostring(self.label or '')
end

function UI:update(dt)
end

function UI:draw()
    if self.styles.bgColor or self.styles.strokeColor then
        if self.styles.bgColor then
            fill(self.styles.bgColor)
        else
            noFill()
        end

        if self.styles.strokeColor then
            stroke(self.styles.strokeColor)
        else
            noStroke()
        end

        rect(0, 0, self.size.x, self.size.y, self.styles.rx, self.styles.ry)
    end

    textColor(self.styles.textColor or colors.white)

    fontName(self.styles.fontName or DEFAULT_FONT_NAME)
    fontSize(self.styles.fontSize or DEFAULT_FONT_SIZE)

    if self.styles.textMode == CORNER then
        textMode(CORNER)
        text(self:getLabel(), self.marge.x, self.marge.y)
        
    else
        textMode(CENTER)
        text(self:getLabel(), self.size.x/2, self.size.y/2-1)
    end
end

function UI:touched(touch)
    if touch.state == RELEASED then
        if self.callback then
            self.callback(self, self.value)
            
        elseif self.click then
            self:click()
        end
    end
end

function UI:wheelmoved(dx, dy)
end
