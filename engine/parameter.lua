class 'Parameter'

function Parameter:init()    
    Parameter.clear(self)
end

function getScreenSize() 
    local w, h = love.graphics.getDimensions()
    return w..'x'..h
end

function getSafeAreaSize() 
    local x, y, w, h = love.window.getSafeArea()
    return x..'x'..y..' '..w..'x'..h
end

function getWindowSize() 
    return W..'x'..H
end

function getMousePosition()    
    return mouse.x..'x'..mouse.y
end

function Parameter:clear()
    self.scene = UIScene()
    self.scene.getOrigin = function () return TOP_LEFT end

    self.scene:setstyles{
        fontSize = 16
    }

    ----------------
    self:menu('Info')
    self:watch('screen', 'getScreenSize()')
    self:watch('safe area', 'getSafeAreaSize()')
    self:watch('window', 'getWindowSize()')
    self:watch('mouse', 'getMousePosition()')

    ----------------
    self:menu('Screen')
    global.bottom_left = false
    global.landscape = env.__mode ~= PORTRAIT

    self:boolean('bottom_left', bottom_left, function (val) setOrigin(val and BOTTOM_LEFT or TOP_LEFT) end)
    self:boolean('landscape', landscape, function (val) supportedOrientations(val and LANDSCAPE_ANY or PORTRAIT) end)

    ----------------
    self:menu('Apps menu', Layout.row)
    self:action('tests all apps', function () loadAppOfTheApps().__autotest = true end)
    self.group:add(ButtonIconFont('loop', restart))
    self:action('apps', loadAppOfTheApps)

    self:newline()
    
    self:action('test app', function () env.__autotest = not env.__autotest end)
    
    self.group:add(ButtonIconFont('heart', randomApp))
    self.group:add(ButtonIconFont('previous', previousApp))
    self.group:add(ButtonIconFont('next', nextApp))

    self.group = self.scene
end

function Parameter:update(dt)
end

function Parameter:default(name, min, max, default, notify)
    local value = loadstring('return _G.env.'..name)()

    if value == nil then
        default = default or min
        if default ~= nil then
            global.__value__ = default
            loadstring('_G.env.'..name..'=global.__value__')()
            self:notify(nil, default, notify)
            return default
        end
    end

    return value
end

function Parameter:set(ui, name, value, notify)
    global.__value__ = value
    loadstring('_G.env.'..name..'=global.__value__')()
    self:notify(ui, value, notify)
end

function Parameter:notify(ui, value, notify)
    if notify then
        notify(value) -- notify(ui, value)
    end
end

function Parameter:menu(name, layout)
    config.show = config.show or table()

    self.group = UINode()
    self.group.visible = not not config.show[name]
    if layout then self.group:setLayoutFlow(layout) end

    local group = self.group
    local button = Button(name, function ()
            group.visible = not group.visible
            config.show[name] = group.visible
            group.size:set()
        end)

    self.scene:add(button)
    self.scene:add(group)
end

function Parameter:newline()
    self.group:add(SeparatorNewLine())
end

function Parameter:action(name, callback)
    self.group:add(
        Button(name,
            function (ui)
                self:notify(ui, ui.label, callback)
            end))
end

function Parameter:watch(name, expression)
    self.group:add(
        Expression(name, expression or name))
end

function Parameter:text(name, text, callback)
    self:default(name, '', '', text, callback)
    self.group:add(
        Editor(name,
            function (ui)
                self:notify(ui, nil, callback)
            end))
end

function Parameter:boolean(name, default, callback)
    local value = self:default(name, false, true, default, callback)
    self.group:add(
        CheckBox(name, value,
            function (ui, value)
                self:set(ui, name, value, callback)
            end))
end

function Parameter:number(name, min, max, default, callback)
    local value = self:default(name, min, max, default, callback)
    self.group:add(
        Slider(name, min, max, value, false,
            function (ui, value)
                self:set(ui, name, value, callback)
            end))
end

function Parameter:integer(name, min, max, default, callback)
    local value = self:default(name, min, max, default, callback)
    self.group:add(
        Slider(name, min, max, value, true,
            function (ui, value)
                self:set(ui, name, value, callback)
            end))
end

function Parameter:color(name, clr, callback)
    local value = self:default(name, colors.white, colors.black, clr, callback)
    self.group:add(
        ColorPicker(name, value,
            function (ui, value)
                self:set(ui, name, value, callback)
            end))
end

function Parameter:link(name, url)
    url = url or name
    self.group:add(
        Button(name,
            function (ui)
                openURL(url)
            end))
end

function Parameter:draw(x, y)
    self.scene:draw(x, y)
end

function Parameter:touched(touch)
    self.scene:touched(touch)
end

function Parameter:wheelmoved(dx, dy)
    self.scene:wheelmoved(dx, dy)
end
