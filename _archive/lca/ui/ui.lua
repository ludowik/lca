class 'UI' : extends(Rect, Bind)

function UI:init(label, callback)
    Rect.init(self)
    
    self.label = tostring(label or '')
    self.callback = callback or nilf

    self.styles = {
        fontSize = 20,
        fontName = 'Arial',
        bgColor = transparent,
        textColor = white,
    }
end

function UI:getLabel()
    return self.label
end

function UI:computeSize()
    fontName(self.styles.fontName)
    fontSize(self.styles.fontSize)
    
    self.size.w, self.size.h = textSize(self:getLabel())
end

function UI:draw()
    self:drawBackground()
    self:drawLabel()
end

function UI:drawBackground()
    noStroke()

    fill(self.styles.bgColor)

    rectMode(CORNER)
    rect(0, 0, self.size.x, self.size.y)
end

function UI:drawLabel()
    self:computeSize()
    
    fontName(self.styles.fontName)
    fontSize(self.styles.fontSize)
    
    fill(self.styles.textColor)
    
    textMode(CORNER)
    text(self:getLabel(), 0, 0)
end

function UI:touched(touch)
end
