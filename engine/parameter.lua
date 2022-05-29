class 'Parameter'

function Parameter:init()
    self.scene = Scene()
--    self.scene.position:set(X+W, Y)

    function self.default(name, min, max, default, notify)
        local value = loadstring('return env.'..name)()

        if value == nil or value == _G[name] then
            default = default or min
            if default ~= nil then
                _G.__value__ = default
                loadstring('env.'..name..'=_G.__value__')()
                if notify then
                    notify(default)
                end
            end
        end
    end

    function self.watch(label, expression)
        self.scene:add(Expression(label, expression or label))
        implement('parameter watch')
    end

    function self.text(label, text, callback)
        self.scene:add(UI(label, callback))
        implement('parameter text')
    end

    function self.color(label, clr, callback)
        self.scene:add(UI(label, callback))
        implement('parameter color')
    end

    function self.action(label, callback)
        self.scene:add(UI(label, callback))
        implement('parameter action')
    end

    function self.boolean(variable, min, max, default, callback)
        self.default(variable, min, max, default, callback)
        self.scene:add(UI(variable, callback))
        implement('parameter watch')
    end

    function self.number(variable, min, max, default, callback)
        self.default(variable, min, max, default, callback)
        self.scene:add(Slider(variable, min, max, default,
                function (self, ...)
                    if callback then callback(...) end
                end
            ))
        implement('parameter watch')
    end

    function self.integer(variable, min, max, default, callback)
        self.default(variable, min, max, default, callback)
        self.scene:add(Slider(variable, min, max, default, callback))
        implement('parameter watch')
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
