class 'Physics'

function Physics.setup()
    Gravity = vec2(0, -9)
end

function Physics:init()
    self.active = true

    self.bodies = table()
    self.joints = table()
end

function Physics:gravity(g)
    self.g = g or self.g
end

function Physics:setArea()
end

function Physics:addItems()
end

function Physics:add(object, ...)
    object.body = self:body(...)
    object.body.item = object
end

function Physics:body(...)
    local body = Body(...)
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
    for i=1,n do
        self:step(dt/n)
    end
end

function Physics:step(dt)
    if not self.active then return end

    for i,body in ipairs(self.bodies) do
        if body.type == DYNAMIC then
            body:applyForce(Gravity)
            body:update(dt)
        end        
    end

    for i,joint in ipairs(self.joints) do
        joint:update(dt)
    end
end

function Physics:draw()
    for i,body in ipairs(self.bodies) do
        body:draw()
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

PhysicsInstance = function ()
    local physics = Physics()

    local interface = {}
    for k,f in pairs(Physics) do
        if type(f) == 'function' then
            interface[k] = function (...)
                return f(physics, ...)
            end
        end
    end

    return interface
end
