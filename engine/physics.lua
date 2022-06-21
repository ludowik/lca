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
end

function Physics:gravity(g)
    self.g = g or self.g
end

function Physics:setArea()
end

function Physics:add(object, ...)
    object.body = self:body(...)
end

function Physics:body()
    return Body()
end

function Physics:addItems()
end

function Physics:pause()
end

function Physics:resume()
end

function Physics:update(dt)
end

function Physics:draw()
end

physics = function ()
    local physics = Physics()
    return {
        gravity = function (...) return physics:gravity(...) end,
        body = function (...) return physics:body(...) end,
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

class 'MeshObject' : extends(Object)

class 'PolygonObject' : extends(Object)
