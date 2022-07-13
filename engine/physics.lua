class 'Physics'

function Physics.setup()
    SPHERE = 'sphere'
    POLYGON = 'polygon'

    STATIC = 'static'
    DYNAMIC = 'dynamic'

    Gravity = vec2()
end

function Physics:init()
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
end

function Physics:resume()
end

function Physics:update(dt)
end

function Physics:draw()
end

function Physics:raycast()
    return nil
end

function Physics:raycastAll()
    return {}
end

physics = function ()
    local physics = Physics()
    return {
        gravity = function (...) return physics:gravity(...) end,
        body = function (...) return physics:body(...) end,
        joint = function (...) return physics:joint(...) end,
        raycast = function (...) return physics:raycast(...) end,
        raycastAll = function (...) return physics:raycastAll(...) end,
        pause = function (...) return physics:pause(...) end,
        resume = function (...) return physics:resume(...) end
    }
end


class 'Body'

function Body:init()
    self:attribs({
            position = vec3(),
            x = 0,
            y = 0,
            z = 0,
            angle = 0,
            radius = 0,
            points = {},
        })
end

function Body:destroy()
end

function Body:applyForce(v)
end

function Body:testOverlap()
end

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

class 'Object' : extends(Rect)

function Object:init()
    Rect.init(self)
end

function Object:addToPhysics(...)
    self.body = env.physics.body(...)
    return self
end

function Object:setPosition(x, y)
    self.position:set(x, y)
    return self
end

function Object:update(dt)
end

class 'Object2D' : extends(Object)
function Object2D:init()
    Object.init(self)
end

class 'Object3D' : extends(Object)
function Object3D:init()
    Object.init(self)
end

class('CircleObject', Object)

function CircleObject:init(x, y, radius)
    Object.init(self)

    self.position:set(x, y)
    self.radius = radius
    self.shapeType = CIRCLE
end

function CircleObject:addToPhysics(bodyType)
    return Object.addToPhysics(self, bodyType or DYNAMIC, self.shapeType, self.radius)
end

class('RectObject', Object)

function RectObject:init(x, y, w, h)
    Object.init(self)

    self.position:set(x, y)
    self.size:set(w, h)
    self.shapeType = POLYGON
end

function RectObject:addToPhysics(bodyType)
    local x, y, w, h = self.position.x, self.position.y, self.size.x, self.size.y
    return Object.addToPhysics(self, bodyType or DYNAMIC, self.shapeType, {
            vec3(x, y),
            vec3(x+w, y),
            vec3(x+w, y+h),
            vec3(x, y+h)
        })
end

class('PolygonObject', Object)

function PolygonObject:init(x, y)
    Object.init(self)

    self.position:set(x, y)
    self.shapeType = POLYGON
end

function PolygonObject:addToPhysics(bodyType)
    return Object.addToPhysics(self, bodyType or DYNAMIC, self.shapeType, self.vertices)
end

class('MeshObject', Object)

function MeshObject:init(object, ...)
    Object.init(self)

    self.shapeType = CIRCLE

    self.object = object
    if object then
        object.shader = object.shader or shaders['default']
    end
end

function MeshObject:addToPhysics(bodyType)
    return Object.addToPhysics(self, bodyType or DYNAMIC, self.shapeType, self.radius)
end

function MeshObject:draw()
    pushMatrix()
    do
        if self.position then
            translate(self.position.x, self.position.y, self.position.z)
        end

        if self.scale then
            scale(self.scale.x, self.scale.y, self.scale.z)
        end

        self.object:draw()
    end
    popMatrix()
end
