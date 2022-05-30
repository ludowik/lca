class 'TimerManager'

function TimerManager.setup()
    TimerManager.timers = table()
end

function TimerManager.update(dt)
    TimerManager.timers:update(dt)
end

class 'Timer'

function Timer:init(delay, callback)
    TimerManager.timers:add(self)
    self.status = 'active'
    self.delay = delay
    self.callback = callback
end

function Timer:update(dt)
    if self.status == 'active' then
        self.delay = self.delay - dt
        if self.delay <= 0 then
            self.status = 'dead'
            self.callback()
        end
    end
end
