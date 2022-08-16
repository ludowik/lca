class 'Parameter'

function Parameter:init()
    Parameter.clear(self)
end

function Parameter:clear()
    self.scene = UIScene()
    self:action('apps', function () loadApp('apps', 'apps') end)
end

function Parameter:update(dt)
end

function Parameter:default(name, min, max, default, notify)
    local value = loadstring('return _G.env.'..name)()

    if value == nil or value == _G[name] then
        default = default or min
        if default ~= nil then
            global.__value__ = default
            loadstring('_G.env.'..name..'=global.__value__')()
            self:notify(nil, default, notify)
        end
    end
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
    self:default(name, false, true, default, callback)
    self.scene:add(
        CheckBox(name, default,
            function (ui, value)
                self:set(ui, name, value, callback)
            end))
end

function Parameter:number(name, min, max, default, callback)
    self:default(name, min, max, default, callback)
    self.scene:add(
        Slider(name, min, max, default, false,
            function (ui, value)
                self:set(ui, name, value, callback)
            end))
end

function Parameter:integer(name, min, max, default, callback)
    self:default(name, min, max, default, callback)
    self.scene:add(
        Slider(name, min, max, default, true,
            function (ui, value)
                self:set(ui, name, value, callback)
            end))
end

function Parameter:color(name, clr, callback)
    self:default(name, colors.white, colors.black, clr, callback)
    self.scene:add(
        ColorPicker(name, clr,
            function (ui, value)
                self:set(ui, name, value, callback)
            end))
end

function Parameter:link(text, url)
end

function Parameter:draw()
    self.scene:draw()
end

function Parameter:touched(touch)
    self.scene:touched(touch)
end

function Parameter:wheelmoved(dx, dy)
    self.scene:wheelmoved(dx, dy)
end

ParameterInstance = function ()
    local parameter = Parameter()

    local interface = {}
    interface.scene = parameter.scene

    for k,f in pairs(Parameter) do
        if type(f) == 'function' then
            interface[k] = function (...)
                return f(parameter, ...)
            end
        end
    end

    return interface
end
