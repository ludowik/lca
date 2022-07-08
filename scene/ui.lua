class 'UIScene' : extends(Scene)

function UIScene:init(layoutFlow)
    Scene.init(self)
    self:setLayoutFlow(layoutFlow or Layout.column)
end

function UIScene:computeSize()
end

function UIScene:setGridSize(n, m)
end

class 'UI' : extends(Rect, Bind)

function UI:init(label, callback)
    Rect.init(self)

    self.label = label or ''
    self.callback = callback

    self.styles = table({
            fontName = DEFAULT_FONT_NAME,
            fontSize = DEFAULT_FONT_SIZE,
        })
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

    self.size.x = max(self.size.x, DEFAULT_FONT_SIZE)
    self.size.y = max(self.size.y, DEFAULT_FONT_SIZE)
end

function UI:getLabel()
    return tostring(self.label or '')
end

function UI:update(dt)
end

function UI:draw()
    self:computeSize()

    if self.styles.bgColor then
        fill(self.styles.bgColor)
        rect(0, 0, self.size.w, self.size.h)
    end

    textColor(self.styles.textColor or colors.white)
    
    fontName(self.styles.fontName or DEFAULT_FONT_NAME)
    fontSize(self.styles.fontSize or DEFAULT_FONT_SIZE)
    
    text(self:getLabel(), 0, 0)
end

function UI:touched(touch)
    if self.callback and touch.state == RELEASED then
        self.callback(self)
    end
end

function UI:wheelmoved(dx, dy)
end

class 'Object'
function Object:update(dt)
end

function Object:draw()
end
