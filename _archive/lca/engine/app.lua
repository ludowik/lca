class 'Application'

function Application:init()
    app.theapp = self
    
    self.scene = Scene()
    self.ui = Scene()
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
end


Apps = table()

function App(name)
    local k = class(name):extends(Application)
    app.theapp = k
    return k
end
