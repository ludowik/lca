-- Helper class to draw and manage physics bodies

PhysicsHelper = class()

function PhysicsHelper:init()
    self.bodies = {}
    self.joints = {}
    self.touchMap = {}
    self.contacts = {}
end

function PhysicsHelper:addBody(body)
    table.insert(self.bodies,body)
end

function PhysicsHelper:addJoint(joint)
    table.insert(self.joints,joint)
end

function PhysicsHelper:clear()
    -- deactivate all bodies
    
    for i,body in ipairs(self.bodies) do
        body:destroy()
    end
    
    for i,joint in ipairs(self.joints) do
        joint:destroy()
    end
    
    self.bodies = {}
    self.joints = {}
end

function PhysicsHelper:draw()
    
    pushStyle()
    smooth()
    strokeWidth(5)
    stroke(128,0,128)
    
    stroke(0,255,0,255)
    strokeWidth(5)
    for k,joint in pairs(self.joints) do
        local a = joint.anchorA
        local b = joint.anchorB
        line(a.x,a.y,b.x,b.y)
    end
    
    stroke(255,255,255,255)
    noFill()
    
    
    for i,body in ipairs(self.bodies) do
        pushMatrix()
        translate(body.x, body.y)
        rotate(body.angle)
        
        if body.type == STATIC then
            stroke(255,255,255,255)
        elseif body.type == DYNAMIC then
            stroke(150,255,150,255)
        elseif body.type == KINEMATIC then
            stroke(150,150,255,255)
        end
        
        if body.shapeType == POLYGON then
            strokeWidth(3.0)
            local points = body.points
            for j = 1,#points do
                a = points[j]
                b = points[(j % #points)+1]
                line(a.x, a.y, b.x, b.y)
            end
        elseif body.shapeType == CHAIN or body.shapeType == EDGE then
            strokeWidth(3.0)
            local points = body.points
            for j = 1,#points-1 do
                a = points[j]
                b = points[j+1]
                line(a.x, a.y, b.x, b.y)
            end
        elseif body.shapeType == CIRCLE then
            strokeWidth(3.0)
            line(0,0,body.radius-3,0)
            ellipse(0,0,body.radius*2)
        end
        
        popMatrix()
    end
    
    popStyle()
end

function PhysicsHelper:touched(touch)
    local touchPoint = vec2(touch.x, touch.y)
    if touch.state == BEGAN then
        for i,body in ipairs(self.bodies) do
            if body.type == DYNAMIC and body:testPoint(touchPoint) then
                self.touchMap[touch.id] = {tp = touchPoint, body = body, anchor = body:getLocalPoint(touchPoint)}
                return true
            end
        end
    elseif touch.state == MOVING and self.touchMap[touch.id] then
        self.touchMap[touch.id].tp = touchPoint
        return true
    elseif touch.state == ENDED and self.touchMap[touch.id] then
        self.touchMap[touch.id] = nil
        return true;
    end
    return false
end
