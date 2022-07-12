App('Icon')

ICON_SIZE = 44

function Icon:init()
    Application.init(self)

    self.position = vec3(100, 100)

    self.ratio = 3
    self.pixelSize = 4
    self.color = colors.white

    ui = UIScene()

    menu = MenuBar()
    menu:add(Button('reset', function (btn) self.drawing:reset() end))

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
        palette:add(
            ButtonColor(Color(i/8),
                function (btn)
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

    if love.filesystem.getInfo(self.iconName) then
        self.drawing.icon = Image(self.iconName)
    else
        self.drawing.icon = Image(ICON_SIZE, ICON_SIZE)
    end
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
end

class('Drawing', UI)

function Drawing:init()
    self:reset()
    UI.init(self)    
end

function Drawing:reset()
    self.icon = Image(ICON_SIZE, ICON_SIZE)

    setContext(self.icon)
    do
        background(self.color)
    end
    setContext()

--    self:save()
end

function Drawing:computeSize()
    self.size.x, self.size.y = self.icon.width * app.ratio, self.icon.height * app.ratio
end

function Drawing:draw()
    spriteMode(CORNER)
    sprite(self.icon, 0, 0, ICON_SIZE, ICON_SIZE)

    local w = self.icon.width * app.ratio
    local h = self.icon.height * app.ratio

    local x = 0
    local y = h

    sprite(self.icon, x, y, w, h)

    stroke(colors.red)
    noFill()

    rectMode(CORNER)
    rect(0, 0, w, h)
end

function Drawing:touched(touch)
    local h = self.icon.height * app.ratio
    local y = HEIGHT - self.absolutePosition.y

    local position = vec2(
        touch.x - self.absolutePosition.x,
        touch.y - self.absolutePosition.y)

--    position:div(app.ratio)

    local i, j
    i = math.floor(position.x / app.pixelSize) * app.pixelSize
    j = math.floor(position.y / app.pixelSize) * app.pixelSize

    setContext(self.icon)
    do
        line(0, 0, i, j)
        
        noStroke()
        fill(self.color)

        rectMode(CORNER)
        rect(i, j, app.pixelSize, app.pixelSize)
    end
    setContext()

--    self:save()
end
