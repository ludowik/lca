class 'Physics'

function Physics.setup()
    Gravity = vec3(0, -9.81)
end

function Physics:init()    
    self.bodies = table()
    self.contacts = table()
    self.joints = table()

    self.pixelRatio = 32

    self:resume()

    interface(self, Physics)
end

function Physics:gravity(g)
    Gravity = g or Gravity
end

function Physics:setArea(x, y, w, h)
    self:add(Object(), STATIC, EDGE, vec3(x, y  ), vec3(x+w, y  ))
    self:add(Object(), STATIC, EDGE, vec3(x, y+h), vec3(x+w, y+h))
    self:add(Object(), STATIC, EDGE, vec3(x  , y), vec3(x  , y+h))
    self:add(Object(), STATIC, EDGE, vec3(x+w, y), vec3(x+w, y+h))
end

function Physics:addItems()
end

function Physics:add(object, shapeType, ...)
    local body = self:body(...)
    body.type = shapeType
    if object then
        object.body, body.object = body, object
        body.position = object.position
    end
    return body
end

function Physics:body(...)
    local body = Body(DYNAMIC, ...)
    body.world = self
    self.bodies:add(body)
    return body
end

function Physics:joint(...)
    local joint = Joint(...)
    self.joints:add(joint)
    return joint
end

function Physics:pause()
    self.active = false
end

function Physics:resume()
    self.active = true
end

function Physics:update(dt)
    if not self.active then return end
    local n = 10
    local dtn = dt/n
    for i=1,n do
        self:step(dtn)
    end
    self:updateProperties()
end

function Physics:step(dt)
    if not self.active then return end

    for i,body in ipairs(self.bodies) do
        if body.type == DYNAMIC then
            body:applyForce(Gravity * body.gravityScale * self.pixelRatio)
            body:update(dt)
        end        
    end

    self:solveCollisions()

    for i,joint in ipairs(self.joints) do
        joint:update(dt)
    end
end

function Physics:updateProperties()
    for _,body in ipairs(self.bodies) do
        if body.object then
            body.object.position = body.position
            body.object.angle = body.angle
        end
    end
end

function Physics:draw()
    for i,body in ipairs(self.bodies) do
        body:draw()
    end
end

function Physics:canCollide(categories, mask)
    for categoryA in ipairs(categories) do
        for categoryB in ipairs(mask) do
            if categoryA == categoryB then
                return true
            end
        end
    end
    return false
end

function Physics:solveCollisions()
    self.contacts = table()

    local bodies = self.bodies
    local contacts = self.contacts

    for i,body in ipairs(self.bodies) do
        body.contact = nil
    end

    -- space partitioning
    local zoneSize = 100

    local zones = {}
    for _,b in ipairs(self.bodies) do
        if b.type == DYNAMIC or b.type == STATIC then
            local i1 = math.floor((b.position.x-b.radius) / zoneSize)
            local j1 = math.floor((b.position.y-b.radius) / zoneSize)

            local i2 = math.floor((b.position.x+b.radius) / zoneSize)
            local j2 = math.floor((b.position.y+b.radius) / zoneSize)

            local function addZone(i, j)
                zones[i..','..j] = zones[i..','..j] or {}
                table.insert(zones[i..','..j], b)
            end

            for i=i1,i2 do
                for j=j1,j2 do
                    addZone(i, j)
                end
            end
        end
    end

    -- detect collisions
    self.checkCollisionsCount = 0

    local function detectCollisions(bodies)
        for i=1,#bodies do
            local b1 = bodies[i]
            for j=i+1,#bodies do
                local b2 = bodies[j]
                if self:canCollide(b1.categories, b2.mask) then
                    self.checkCollisionsCount = self.checkCollisionsCount + 1

                    local direction = b2.position - b1.position 
                    local dist = direction:len()
                    local distMax = b1.radius + b2.radius

                    -- collision
                    if dist < distMax then
                        local contact = Contact(b1, b2)
                        contacts:insert(contact)

                        b1.contact = b2
                        b2.contact = b1

                        --b1.linearVelocity, b2.linearVelocity = b2.linearVelocity, b1.linearVelocity
                        --local angle = b1.linearVelocity:angleBetween(b2.linearVelocity)

                        local n = direction:normalize()

                        local p = 2 * (
                            b1.linearVelocity.x * n.x +
                            b1.linearVelocity.y * n.y -
                            b2.linearVelocity.x * n.x -
                            b2.linearVelocity.y * n.y ) / (b1.mass + b2.mass)

                        b1.linearVelocity.x = b1.linearVelocity.x - p * b1.mass * n.x
                        b1.linearVelocity.y = b1.linearVelocity.y - p * b1.mass * n.y

                        b2.linearVelocity.x = b2.linearVelocity.x + p * b2.mass * n.x
                        b2.linearVelocity.y = b2.linearVelocity.y + p * b2.mass * n.y

                        direction = direction:normalize() * (distMax - dist)

                        b1.position = b1.position - direction / 2
                        b2.position = b2.position + direction / 2
                    end

                end
            end 
        end
    end

    for k,zone in pairs(zones) do
        detectCollisions(zone)
    end

    for _,contact in ipairs(contacts) do
        local b1 = contact.bodyA
        local b2 = contact.bodyB

        Engine.collide(contact)
    end
end

-- Performs a raycast from the start point to the end point.
-- Any additional parameters are treated as category filters, allowing certain bodies to be ignored.
-- This function only returns hit information on the closest rigid body detected.
function Physics:raycast(from, to, category1, category2)
    -- TODO : raycast
end

-- Performs a raycast from the start point to the end point.
-- Any additional parameters are treated as category filters, allowing certain bodies to be ignored.
-- This function returns an array of tables describing all objects hit along the ray, ordered from closest to farthest.
function Physics:raycastAll(from, to, category1, category2)
    -- TODO : raycastAll
    return {}
end

-- Performs a query to find all bodies within the supplied axis-aligned bounding box.
-- Any additional parameters are treated as category filters, allowing certain bodies to be ignored.
function Physics:queryAABB(lowerLeft, upperRight, category1, category2)
    -- TODO : queryAABB
    return {}
end
