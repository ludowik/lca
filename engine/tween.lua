class 'TweensManager'

function TweensManager.setup()
    TweensManager.tweens = table()
end

function TweensManager.update(dt)
    TweensManager.tweens:call('update', dt)
end

class 'Tween'

function Tween:init(object, target, delay, callback)
    TweensManager.tweens:insert(self)

    self.active = true

    self.object = object    
    self.target = target

    self.source = table()    
    for k,v in pairs(target) do
        self.source[k] = self.object[k]
    end    

    self.delay = delay
    self.elapsed = 0

    self.callback = callback
end

function Tween:update(dt)
    if self.active then
        self.elapsed = self.elapsed + dt

        for k,v in pairs(self.target) do
            self.object[k] = easing(self.object[k], self.source[k], self.target[k], dt, self.delay)
        end

        log('update tween')

        if self.elapsed >= self.delay then 
            self.active = false
            if self.callback then
                self.callback()
            end
        end
    end
end

function easing(current, source, target, dt, delay)
    return current + (target - source) * (dt / delay)
end
