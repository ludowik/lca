class 'Button' : extends(UI)

function Button:init(label, callback)
    UI.init(self, label, callback)

    self:setstyles{
        bgColor = colors.blue,
        strokeColor = colors.lightgray,
        textColor = colors.white,
        textMode = CENTER,
        rx = 4,
    }
end

class 'ButtonColor' : extends(UI)

function ButtonColor:init(bgColor, callback)
    UI.init(self, '', callback)
    self:setstyles{
        bgColor = bgColor,
    }
end

class('ButtonIconFont', Button)

function ButtonIconFont:init(label, action)
    Button.init(self, label, action)
end

function ButtonIconFont:computeSize()
    self.size.x, self.size.y = 32, 32
end

function ButtonIconFont:draw()
    local x, y = 0, 0

    pushStyle()
    do
        noStroke()

        fill(colors.white)

        fontName('Foundation-Icons')
        fontSize(self.size.x)

        textMode(CENTER)
        text(utf8.char(iconsFont[self.label]),
            x + self.size.x/2,
            y + self.size.y/2)
    end
    popStyle()
end

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
    stroke(colors.white)

    noFill()

    rectMode(CORNER)
    rect(0, 0, self.size.x, self.size.y)

    spriteMode(CORNER)
    sprite(self.image,
        0, 0,
        self.size.x, self.size.y)
end
