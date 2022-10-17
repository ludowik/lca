class 'Parameter'

function Parameter:init()    
    Parameter.clear(self)
end

function Parameter:clear()    
    self.scene = UIScene()
    self.scene.getOrigin = function () return TOP_LEFT end

--    _G.env.bottom_left = getOrigin() == BOTTOM_LEFT

    -------
    self.group = UINode()
    self.group.visible = config.showAppsMenu
    local group = self.group
    self.button = Button('Apps menu', function ()
            group.visible = not group.visible
            config.showAppsMenu = group.visible
            group.size:set()
        end)

    self.scene:add(self.button)
    self.scene:add(group)

    self:action('restart', restart)
    self:action('apps', loadAppOfTheApps)
    self:action('tests all apps', function () loadAppOfTheApps().__autotest = true end)
    self:action('test app', function () env.__autotest = not env.__autotest end)
    self:action('next app', nextApp)
    self:action('previous app', previousApp)
    self:action('random app', randomApp)

    self:boolean('bottom_left', false, function (val) setOrigin(val and BOTTOM_LEFT or TOP_LEFT) end)
    self:boolean('landscape', false, function (val) supportedOrientations(val and LANDSCAPE_ANY or PORTRAIT) end)
    -------

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
