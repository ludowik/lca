class 'Parameter'

function Parameter:init()    
    Parameter.clear(self)

    self.scene.WMAX = config.WMAX or 0
end

function getScreenSize()
    local w, h = love.graphics.getDimensions()
    return w..'x'..h
end

function getSafeAreaSize() 
    local x, y, w, h = getSafeArea()
    return x..'x'..y..' '..w..'x'..h
end

function getWindowSize() 
    return W..'x'..H
end

function getMousePosition()    
    return mouse.x..'x'..mouse.y
end

function Parameter:clear()
    self.scene = UIScene(Layout.column)
    self.scene.getOrigin = function () return TOP_LEFT end

    self.scene:setstyles{
        fontSize = 14
    }

    self.scene:add(
        ButtonColor(colors.red, -- 'Menu', 
            function ()
                config.WMAX = self.scene.WMAX == screenConfig.WMAX and (screenConfig.WT-screenConfig.X-screenConfig.W) or screenConfig.WMAX
                tween(0.2, self.scene, {WMAX = config.WMAX}, tween.easing.sineIn)
            end))
    
    self.scene.WMAX = 0

    self.globalGroup = UINode(Layout.column)
    self.scene:add(self.globalGroup)

    local group = UINode()
    self.globalGroup:add(group)

    ----------------
    self.group = group
    self:menu(env.appName)
    self:watch('screen', 'getScreenSize()')
    self:watch('safe area', 'getSafeAreaSize()')
    self:watch('window', 'getWindowSize()')
    self:watch('mouse', 'getMousePosition()')
    self:watch('config.framework')
    self:watch('config.renderer')

    ----------------
    self.group = group
    self:menu('Apps menu', Layout.row)
    self.group:add(ButtonIconFont('loop', restart))
    self.group:add(ButtonIconFont('list_bullet', loadAppOfTheApps))

    self.group:add(ButtonIconFont('die_one', function () env.__autotest = not env.__autotest end))
    self.group:add(ButtonIconFont('heart', randomApp))
    self.group:add(ButtonIconFont('previous', previousApp))
    self.group:add(ButtonIconFont('next', nextApp))

    self.group:add(ButtonIconFont('photo', function () Engine.captureImage('captures') end))

    self.group:add(ButtonIconFont(getOrigin() == TOP_LEFT and 'arrow_up' or 'arrow_down',
            function (btn)
                setOrigin(getOrigin() == TOP_LEFT and BOTTOM_LEFT or TOP_LEFT)
                btn.label = getOrigin() == TOP_LEFT and 'arrow_up' or 'arrow_down'
                self.scene.WMAX = screenConfig.WMAX
            end))

    self.group:add(ButtonIconFont(getOrientation() == PORTRAIT and 'tablet_landscape' or 'tablet_portrait',
            function (btn)
                setOrientation(getOrientation() == PORTRAIT and LANDSCAPE or PORTRAIT)
                btn.label = getOrientation() == PORTRAIT and 'tablet_landscape' or 'tablet_portrait'
                self.scene.WMAX = screenConfig.WMAX
            end))

    _G.SCALE_APP = 1
    
    self:number('_G.SCALE_APP', 0.25, 2, _G.SCALE_APP,
        function ()
            setOrientation()
        end)

    self.group = UINode()
    self.globalGroup:add(self.group)
end

function Parameter:random()
    seed(time())

    for i,ui in ipairs(self.group:items()) do
        if ui.__className == 'Slider' then
            local value
            if ui.integer then
                value = randomInt(ui.min, ui.max)
            else
                value = random(ui.min, ui.max)
            end
            ui:setValue(value)

        elseif ui.__className == 'CheckBox' then
            ui:setValue(randomBoolean())

        elseif ui.__className == 'ColorPicker' then
            ui:setValue(Color.random())
        end
    end 
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

    local group = UINode(layout)
    group.visible = not not config.show[name]

    local button = Button(name,
        function ()
            group.visible = not group.visible
            config.show[name] = group.visible
            group.size:set()
        end)

    self.group:add(button)
    self.group:add(group)

    self.group = group
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

function Parameter:draw()
    noStroke()
    fill(Color(0.5, 0.5, 0.5, 0.9))

    local x, y
    if getOrientation() == LANDSCAPE then
        x, y = screenConfig.W - env.parameter.instance.scene.WMAX, 0
    else
        x, y = 0, screenConfig.W - env.parameter.instance.scene.WMAX
    end

    rect(x, y, screenConfig.W, screenConfig.H, 10)

    self.scene:draw(x, y)
end

function Parameter:touched(touch)
    return self.scene:touched(touch)
end

function Parameter:wheelmoved(dx, dy)
    self.scene:wheelmoved(dx, dy)
end
