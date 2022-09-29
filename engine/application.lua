class 'Application'

function Application:init()
    _G.env.app = self

    self.scene = Scene()
    self.ui = UIScene()
end

function Application:pushScene(scene)
    push(self, self.scene)
    self.scene = scene
end

function Application:popScene()
    self.scene = pop(scene)
end

function Application:pushUI(ui)
    push(self, self.ui)
    self.ui = ui
end

function Application:popUI()
    self.ui = pop(self)
end

function Application:update(dt)
    self:updateCoroutine(dt)
end

function Application:updateCoroutine(dt)
    if self.thread then
        local status = coroutine.status(self.thread)
        if status ~= 'dead' then
            local res, error = coroutine.resume(self.thread, dt)
            if not res then
                print(error)
                assert(res, error)
            end
            status = coroutine.status(self.thread)
            if status == 'dead' then
                self.thread = nil
                Application.endCoroutine(self)
            end
        end
    end
end

function Application:endCoroutine()
end

function Application:draw()
    background(colors.black)

    self.scene:draw()
    self.ui:draw()
end

function Application:touched(touch)
    self.scene:touched(touch)
    self.ui:touched(touch)
end

function App(name)    
    local k = class(name) : extends(Application)

    local app

    _G.env.setup = function()
        app = k()
        _G.env.app = app

        if k.update then
            _G.env.update = function (dt)
                app:update(dt)
            end
        end

        if k.draw then
            _G.env.draw = function ()
                app:draw()
            end
        end

        if k.draw3d then
            _G.env.draw3d = function ()
                app:draw3d()
            end
        end
        
        if k.touched then
            _G.env.touched = function ()
                app:touched()
            end
        end
    end
end
