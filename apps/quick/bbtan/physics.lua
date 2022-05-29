Physics = class()

function Physics.setup()
    CIRCLE = 'circle'
    RECT = 'rect'
end

function Physics:init(xg, yg)
    self.bodies = table()
    self.edges = table()
end

function Physics:body(entity, shapeType)
    local body = Body('dynamic', shapeType)
    self.bodies:add(body)
    
    body.position:copy(entity.position)
    body.size:copy(entity.size)
    
    body.r = entity.size.w
    
    entity.body = body
end

function Physics:edge(x1, y1, x2, y2)
    local edge = Body('static', 'edge')
    self.bodies:add(body)
    
    edge.position:set(x1, y2)
    edge.size:set(x2-x1, y2-y1)
    
    self.edges:add(edge)
end

function Physics:update(dt)
    for _,body in ipairs(self.bodies) do
        body:update(dt)
        
        for _,edge in ipairs(self.edges) do
            if lineIntersectCircle(edge, body) then
                local angleBetween = edge.size:angleBetween(body.linearVelocity)
                local normal = (
                    edge.size:rotate(-sign(angleBetween)*PI/2):normalize() +
                    body.linearVelocity:normalize()):normalize()
                
                body.linearVelocity.x = body.linearVelocity.x * normal.x
                body.linearVelocity.y = body.linearVelocity.y * normal.y
                
                body:update(16/1000)
            end
        end
    end
end

function Physics:draw()
end

Body = class()

function Body:init(bodyType, shapeType)
    self.bodyType = bodyType
    self.shapeType = shapeType
    
    self.friction = 0.8
    self.restitution = 0.8
    
    self.position = vec2()
    self.size = vec2()
    
    self.linearVelocity = vec2()
end

function Body:setType(bodyType)
    self.bodyType = bodyType
end

function Body:setFriction(friction)
end

function Body:setRestitution(restitution)
end

function Body:setLinearVelocity(x, y)
    self.linearVelocity:set(x, y)
end

function Body:getX()
    return self.position.x
end

function Body:getY()
    return self.position.y
end

function Body:update(dt)
    self.position.x = self.position.x + self.linearVelocity.x * dt
    self.position.y = self.position.y + self.linearVelocity.y * dt
end
