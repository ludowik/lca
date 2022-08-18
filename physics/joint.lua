class 'Joint'

function Joint.setup()
    REVOLUTE = 'revolute'
    DISTANCE = 'distance'
    PRISMATIC = 'prismatic'
    WELD = 'weld'
    ROPE = 'rope'
end

function Joint:init(jointType, ...)
    self.jointType = jointType

    if jointType == REVOLUTE then
        self.bodyA, self.bodyB, self.anchorA = ...
        self.anchorB = self.anchorA
    
    elseif jointType == PRISMATIC then
        self.bodyA, self.bodyB, self.anchorA, self.direction = ...
        self.anchorB = self.anchorA + self.direction 
    
    elseif jointType == DISTANCE then
        self.bodyA, self.bodyB, self.anchorA, self.anchorB = ...
    
    elseif jointType == WELD then
        self.bodyA, self.bodyB, self.anchorA = ...
        self.anchorB = self.anchorA
        
    elseif jointType == ROPE then
        self.bodyA, self.bodyB, self.anchorA, self.anchorB, self.maxLength = ...
        
    else
        self.bodyA, self.bodyB, self.anchorA, self.anchorB = ...
    end
    
    assert(self.anchorB)

end

function Joint:destroy()
end

function Joint:update(dt)
    if self.jointType == ROPE then
                
        local direction = self.bodyB.position - self.bodyA.position
        local dist = direction:len()
        
        local position = self.bodyA.position
        local b = self.bodyB
        local radius = self.maxLength
        
        if dist > radius - self.bodyB.radius then
            local n = direction:normalize()
            
            b.positionOld = b.position
            b.position = position + n * (radius - b.radius)
            
            --direction = b.position - position
            
            local angle = b.linearVelocity:angleBetween(direction)
            b.linearVelocity = -b.linearVelocity:rotate(angle*2)
            
            if b.linearVelocity:len() > 500 then
                b.linearVelocity = b.linearVelocity:normalize() * 10
            else
                b.linearVelocity = b.linearVelocity * math.pow(0.5, dt)
            end
        end        
        
    end
end
