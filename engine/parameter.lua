class 'Parameter'

function Parameter:init()    
    Parameter.clear(self)
end

function Parameter:clear()    
    self.scene = UIScene()
    self.scene.origin = nil
    
    _G.env.bottom_left = getOrigin() == BOTTOM_LEFT
    
    self:action('apps', loadAppOfTheApps)
    
    self:boolean('bottom_left', false, function (val) setOrigin(val and BOTTOM_LEFT or TOP_LEFT) end)
    self:boolean('landscape', false, function (val) supportedOrientations(val and LANDSCAPE_ANY or PORTRAIT) end)
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
    self.scene:add(
        Button(name,
            function (ui)
                self:notify(ui, ui.label, callback)
            end))
end

function Parameter:watch(name, expression)
    self.scene:add(
        Expression(name, expression or name))
end

function Parameter:text(name, text, callback)
    self:default(name, '', '', text, callback)
    self.scene:add(
        Editor(name,
            function (ui)
                self:notify(ui, nil, callback)
            end))
end

function Parameter:boolean(name, default, callback)
    local value = self:default(name, false, true, default, callback)
    self.scene:add(
        CheckBox(name, value,
            function (ui, value)
                self:set(ui, name, value, callback)
            end))
end

function Parameter:number(name, min, max, default, callback)
    local value = self:default(name, min, max, default, callback)
    self.scene:add(
        Slider(name, min, max, value, false,
            function (ui, value)
                self:set(ui, name, value, callback)
            end))
end

function Parameter:integer(name, min, max, default, callback)
    local value = self:default(name, min, max, default, callback)
    self.scene:add(
        Slider(name, min, max, value, true,
            function (ui, value)
                self:set(ui, name, value, callback)
            end))
end

function Parameter:color(name, clr, callback)
    local value = self:default(name, colors.white, colors.black, clr, callback)
    self.scene:add(
        ColorPicker(name, value,
            function (ui, value)
                self:set(ui, name, value, callback)
            end))
end

function Parameter:link(name, url)
    url = url or name
    self.scene:add(
        Button(name,
            function (ui)
                openURL(url)
            end))
end

function Parameter:draw(x, y)
    if x then
        self.scene.position:set(x, y)
    end
    
    self.scene:draw()
end

function Parameter:touched(touch)
    self.scene:touched(touch)
end

function Parameter:wheelmoved(dx, dy)
    self.scene:wheelmoved(dx, dy)
end
