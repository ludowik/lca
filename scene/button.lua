class 'Button' : extends(UI)

function Button:init(label, callback)
    UI.init(self, label, callback)
    self.styles:attribs{
        bgColor = colors.blue,
        textColor = colors.white,
    }
end

class 'ButtonColor' : extends(UI)

function ButtonColor:init(bgColor, callback)
    UI.init(self, '', callback)
    self.styles:attribs{
        bgColor = bgColor
    }
end

class 'ButtonIconFont' : extends(Button)

class 'ButtonImage' : extends(Button)

function ButtonImage:init(label, action)
    Button.init(self, label, action)

    self.image = Image(label)
end

function ButtonImage:computeSize()
    self.size.x, self.size.y = 48, 32
    self.size = self.size * 2
end

function ButtonImage:draw()
    stroke(white)

    noFill()

    rectMode(CORNER)
    rect(0, 0, self.size.x, self.size.y)

    spriteMode(CORNER)
    sprite(self.image,
        0, 0,
        self.size.x, self.size.y)
end
