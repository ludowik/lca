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
                if notify then
                    notify(default)
                end
            end
        end
    end

    function self.set(name, value, notify)
        global.__value__ = value
        loadstring('_G.env.'..name..'=global.__value__')()
--        if notify then
--            notify(default)
--        end
    end

    function self.watch(label, expression)
        self.scene:add(Expression(label, expression or label))
        implement('parameter watch')
    end

    function self.text(label, text, callback)
        self.scene:add(UI(label, function (ui)
                    if callback then callback(ui) end
                end))
        implement('parameter text')
    end

    function self.color(label, clr, callback)
        self.scene:add(UI(label, function (ui)
                    if callback then callback(ui) end
                end))
        implement('parameter color')
    end

    function self.action(label, callback)
        self.scene:add(UI(label, function (ui)
                    if callback then callback(ui) end
                end))
        implement('parameter action')
    end

    function self.boolean(variable, default, callback)
        self.default(variable, false, true, default, callback)
        self.scene:add(UI(variable, function (ui)
                    if callback then callback(ui) end
                end))
        implement('parameter watch')
    end

    function self.number(variable, min, max, default, callback)
        self.default(variable, min, max, default, callback)
        self.scene:add(Slider(variable, min, max, default, false,
                function (ui, value)
                    self.set(variable, value)
                    if callback then callback(ui, value) end
                end
            ))
        implement('parameter watch')
    end

    function self.integer(variable, min, max, default, callback)
        self.default(variable, min, max, default, callback)
        self.scene:add(Slider(variable, min, max, default, true,
                function (ui)
                    if callback then callback(ui) end
                end))
        implement('parameter watch')
    end

    function self.link(text, url)
    end

    function self.draw()
        self.scene:draw()
    end

    function self.touched(touch)
        print(touch.x, touch.y)
        print(self.scene.position.x, self.scene.position.y)

        self.scene:touched(touch)
        for i,v in ipairs(self.scene:items()) do
            print(v.position.x, v.position.y)
        end

    end
end
