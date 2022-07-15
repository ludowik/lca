class 'Joint'

-- TODO
REVOLUTE = 'revolute'

function Joint:init(jointType, bodyA, bodyB, anchor)
    self.type = jointType
    self.bodyA = bodyA
    self.bodyB = bodyB
    self.anchorA = anchor
    self.anchorB = anchor
end

function Joint:destroy()
end
