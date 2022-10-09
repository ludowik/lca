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

function Body:init(bodyType, shapeType, ...)
    self.type = bodyType
    self.shapeType = shapeType

    self.position = vec2()
    self.positionPrevious = self.position:clone()

    self.angle = 0
    self.anglePrevious = 0
    
    self.radius = 0
    
    self.points = table()

    if shapeType == CIRCLE then
        local radius = ...
        self.radius = radius or 20

    elseif shapeType == POLYGON then
        local t = table{...}
        if t[1] and t[1].x then
            self.points = t
        else
            self.points = ...
        end
    end

    self.gravityScale = 1
    
    self.acceleration = vec2()
    self.linearVelocity = vec2()
    
    self.torque = 0
    self.angularVelocity = 0

    self.mass = 1
    
    self.categories = {0}
    self.mask = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}
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
    self.acceleration = self.acceleration + force
end

function Body:applyLinearImpulse(impulse)
    self.linearVelocity = self.linearVelocity + impulse
end

function Body:applyTorque(torque)
    self.torque = self.torque + torque
end

function Body:applyAngularImpulse(impulse)
    self.anle = self.angle + impulse
end

function Body:testOverlap(otherBody)
    return Collision.collide(self, otherBody)
end

function Body:getLocalPoint(worldPoint)
    return worldPoint - self.position
end

function Body:getWorldPoint(localPoint)
    return localPoint + self.position
end

function Body:update(dt)
    -- linear velocity
    self.linearVelocity = self.linearVelocity + self.acceleration * dt

    self.positionPrevious:set(self.position)
    self.position = self.position + self.linearVelocity * dt

    self.acceleration = vec2()

    -- linear damping
    local damping = 0.8
    self.linearVelocity = self.linearVelocity * math.pow(damping, dt)

    -- angular velocity
    self.angularVelocity = self.angularVelocity + self.torque * dt
    
    self.anglePrevious = self.angle
    self.angle = self.angle + self.angularVelocity * dt
    
    self.torque = 0
end

function Body:draw()
    noStroke()
    fill(self.linearVelocity:len(), 0, 200)
    ellipse(self.position.x, self.position.y, 2 * self.radius)
end

function Body:testPoint(x, y)
    return false
end
