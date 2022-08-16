class 'Body'

function Body.setup()
    DYNAMIC = 'dynamic'
    STATIC = 'static'
    KINEMATIC = 'kinematic'

    CIRCLE = 'circle'
    POLYGON = 'polygon'
    RECT = 'rect'
    CHAIN = 'chain'
    EDGE = 'edge'
    SPHERE = 'sphere'
end

function Body:init(shapeType, ...)
    self.type = DYNAMIC
    self.shapeType = shapeType

    self.position = vec2()

    self.radius = 0
    self.points = table()

    self.angle = 0    

    if shapeType == CIRCLE then
        self.radius = ...

    elseif shapeType == POLYGON then
        local t = table{...}
        if t[1].x then
            self.points = t
        else
            self.points = ...
        end
    end

    self.acceleration = vec2()

    self.linearVelocity = vec2()
    self.angularVelocity = vec2()
end

function Body:destroy()
end

function Body.properties.set:x(x)
    self.position.x = x or 0
end

function Body.properties.set:y(y)
    self.position.y = y or 0
end

function Body.properties.get:x()
    return self.position.x
end

function Body.properties.get:y()
    return self.position.y
end

function Body:applyForce(force)
    self.acceleration = self.acceleration + force * 32
end

function Body:applyLinearImpulse(ix, iy)
end

function Body:update(dt)
    self.linearVelocity = self.linearVelocity + self.acceleration * dt

    self.positionOld = self.position
    self.position = self.position + self.linearVelocity * dt

    self.acceleration = vec2()

    -- linear damping
    local damping = 0.8
    self.linearVelocity = self.linearVelocity * math.pow(damping, dt)
end

function Body:draw()
    noStroke()
    fill(self.linearVelocity:len(), 0, 200)
    ellipse(self.position.x, self.position.y, 2 * self.radius)
end

function Body:testPoint(x, y)
    return false
end

function Body:testOverlap()
end
