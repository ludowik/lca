App('Icon')

ICON_SIZE = 44

function Icon:init()
    Application.init(self)

    self.position = vec3(100, 100)

    self.ratio = 3
    self.pixelSize = 4
    self.color = white

    ui = UIScene()

    menu = MenuBar()
    menu:add(Button('reset', function (btn) self:reset() end))

    local function load(btn)
        self:load(btn.label)
    end
    
    menu:add(Button('quit', load))
    menu:add(Button('restart', load))
    menu:add(Button('menu', load))
    menu:add(Button('next', load))
    menu:add(Button('previous', load))
    menu:add(Button('play', load))

    palette = ToolBar(0, ICON_SIZE)
    for i = 0,8 do
        palette:add(ButtonColor(color(i/8), function (btn)
                    self:setColor(btn.color)
                end))
    end

    ui:add(menu, palette)

    self.drawing = Drawing()
    ui:add(self.drawing)

    self:load('quit')
end

function Icon:setColor(color)
    self.color = color
end

function Icon:load(iconName)
    self.iconName = iconName
    self.drawing.icon = image(self.iconName) or image(ICON_SIZE, ICON_SIZE)
end

function Icon:save()
    self.drawing.icon:save(self.iconName)
end

function Icon:draw()
    background(51)

    ui:layout()
    ui:draw()
end

function Icon:touched(touch)
    ui:touched(touch)

    local h = self.drawing.icon.height * theapp.ratio
    local y = HEIGHT - self.drawing.absolutePosition.y

    touch.x = touch.x - self.drawing.absolutePosition.x
    touch.y = touch.y - y

    touch = touch.position / theapp.ratio

    local i, j
    i = math.floor(touch.x / self.pixelSize) * self.pixelSize
    j = math.floor(touch.y / self.pixelSize) * self.pixelSize

    setContext(self.drawing.icon)
    do
        noStroke()
        fill(self.color)

        rectMode(CORNER)
        rect(i, j, self.pixelSize, self.pixelSize)
    end
    setContext()

    self:save()
end

class('Drawing', UI)

function Drawing:init()
    self:reset()
    UI.init(self)    
end

function Drawing:reset()
    self.icon = image(ICON_SIZE, ICON_SIZE)

    setContext(self.icon)
    do
        background(self.color)
    end
    setContext()

--    self:save()
end

function Drawing:computeSize()
    self.size.x, self.size.y = self.icon.width * theapp.ratio, self.icon.height * theapp.ratio
end

function Drawing:draw()
    spriteMode(CORNER)
    sprite(self.icon, 0, 0, ICON_SIZE, ICON_SIZE)

    local w = self.icon.width * theapp.ratio
    local h = self.icon.height * theapp.ratio

    local x = 0
    local y = -h

    sprite(self.icon, x, y, w, h)

    stroke(red)
    noFill()

    rectMode(CORNER)
    rect(0, 0, w, h)
end

