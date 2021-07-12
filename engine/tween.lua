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
    
    self.delay = delay    

    self:reset()
    
    self.easing = Easing.linear

    self.callback = callback
end

function Tween:play()
    self.active = true
end

function Tween:stop()
    self.active = false
end

function Tween:reset()
    self.source = table()
    for k,v in pairs(self.target) do
        self.source[k] = self.object[k]
    end

    self.elapsed = 0
end

function Tween:remove()
    TweensManager.tweens:removeItem(self)
end

function Tween:update(dt)
    if self.active then
        self.elapsed = self.elapsed + dt

        for k,v in pairs(self.target) do
            self.object[k] = self.easing(self.object[k], self.source[k], self.target[k], dt, self.delay)
        end

        if self.elapsed >= self.delay then 
            self.active = false
            if self.callback then
                self.callback(self)
            end
        end
    end
end

class 'Easing'

function Easing.linear(current, source, target, dt, delay)
    return current + (target - source) * (dt / delay)
end
