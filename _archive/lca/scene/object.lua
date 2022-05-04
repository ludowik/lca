class 'Object' : extends(Rect)

function Object:init(label, x, y, vx, vy)
    Rect.init(self)
    
    self.label = label
    
    self.state = "active"
    
    self.size = vec2()
    
    self.position = vec2(x, y)  
    self.linearVelocity = vec2(vx, vy)
    
    self.angle = 0
    self.angularVelocity = 0
end

function Object:destroy()
end

function Object:update(dt)
    self.position = self.position + self.linearVelocity * dt
    
    self.angle = self.angle + self.angularVelocity * dt
    
    if self.position.y < -H or self.position.y > H*2 then
        self.state = "dead"
    end
    
    if self.deltaTime then
        self.deltaTime = self.deltaTime + dt
    end
    
    if self.delay then
        self.delay = self.delay - dt
        if self.delay < 0 then
            self.state = "dead"
        end
    end
    
    if self.target and self.offset then
        self.linearVelocity = (self.target - self.offset - self.position) * 10
    end
    
    self.fixedSize = nil
    self.gridSize = nil
end

function Object:setFixedSize(x, y)
    x = x or ws()
    y = y or hs()

    self.fixedSize = vec2(x, y)
    return self
end

function Object:setGridSize(i, j)
    i = i or 1
    j = j or 1

    self.gridSize = vec2(i, j)
    return self
end

Object2D  = Object
Object3D  = Object
