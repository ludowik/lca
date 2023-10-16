App('Icon')

ICON_SIZE = 44

function Icon:init()
    Application.init(self)

    self.position = vec3(100, 100)

    self.ratio = 8
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
                    self:setColor(btn.styles.bgColor)
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
        background(app.color)
    end
    setContext()

    self:save()
end

function Drawing:computeSize()
    self.size.x, self.size.y = ICON_SIZE * app.ratio, ICON_SIZE * app.ratio * 2
end

function Drawing:draw()
    spriteMode(CORNER)

    local x = 0
    local y = 0

    local w = self.icon.width * app.ratio
    local h = self.icon.height * app.ratio

    sprite(self.icon, x, y, w, h)

    stroke(colors.red)
    noFill()

    rectMode(CORNER)
    rect(0, 0, w, h)

    sprite(self.icon, 0, h, ICON_SIZE, ICON_SIZE)
end

function Drawing:save()
    self.icon:save(self.iconName)
end

function Drawing:touched(touch)
    if touch.state == RELEASED then return end

    local h = self.icon.height * app.ratio
    local y = HEIGHT - self.absolutePosition.y

    local position = vec2(
        touch.x - self.absolutePosition.x,
        touch.y - self.absolutePosition.y)

    position:div(app.ratio)

    local i, j
    i = math.floor(position.x / app.pixelSize) * app.pixelSize
    j = math.floor(position.y / app.pixelSize) * app.pixelSize

    setContext(self.icon)
    do        
        noStroke()

        if isButtonDown(BUTTON_LEFT) then
            fill(app.color)
        else
            fill(colors.black)
        end

        rectMode(CORNER)
        rect(i, j, app.pixelSize, app.pixelSize)
    end
    setContext()

    self:save()
end
