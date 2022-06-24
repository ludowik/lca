class 'Parameter'

function Parameter:init()
    self.scene = Scene()

    function self.default(name, min, max, default, notify)
        local value = loadstring('return _G.env.'..name)()

        if value == nil or value == _G[name] then
            default = default or min
            if default ~= nil then
                global.__value__ = default
                loadstring('_G.env.'..name..'=global.__value__')()
                self.notify(nil, default, notify)
            end
        end
    end

    function self.set(ui, name, value, notify)
        global.__value__ = value
        loadstring('_G.env.'..name..'=global.__value__')()
        self.notify(ui, value, notify)
    end

    function self.notify(ui, value, notify)
        if notify then
            notify(value) -- notify(ui, value)
        end
    end
    
    function self.action(name, callback)
        self.scene:add(
            Button(name,
                function (ui)
                    self.notify(ui, ui.label, callback)
                end))
    end

    function self.watch(name, expression)
        self.scene:add(
            Expression(name, expression or name))
    end

    function self.text(name, text, callback)
        self.scene:add(
            UI(name,
                function (ui)
                    self.notify(ui, nil, callback)
                end))
    end

    function self.boolean(name, default, callback)
        self.default(name, false, true, default, callback)
        self.scene:add(
            CheckBox(name, default,
                function (ui, value)
                    self.set(ui, name, value, callback)
                end))
    end

    function self.number(name, min, max, default, callback)
        self.default(name, min, max, default, callback)
        self.scene:add(
            Slider(name, min, max, default, false,
                function (ui, value)
                    self.set(ui, name, value, callback)
                end))
    end

    function self.integer(name, min, max, default, callback)
        self.default(name, min, max, default, callback)
        self.scene:add(
            Slider(name, min, max, default, true,
                function (ui, value)
                    self.set(ui, name, value, callback)
                end))
    end
    
    function self.color(name, clr, callback)
        self.default(name, colors.white, colors.black, clr, callback)
        self.scene:add(
            ColorPicker(name, clr,
                function (ui, value)
                    self.set(ui, name, value, callback)
                end))
    end

    function self.link(text, url)
    end

    function self.draw()
        self.scene:draw()
    end

    function self.touched(touch)
        self.scene:touched(touch)
    end
end
