physics = class 'Physics'

function physics.setup()
    SPHERE = 'sphere'
    POLYGON = 'polygon'

    STATIC = 'static'
    DYNAMIC = 'dynamic'

    Gravity = vec2()
end

function physics:init()
    self.bodies = table()
end

function physics.gravity(g)
    physics.g = g or physics.g
end

function physics.pause()
end

function physics.resume()
end

function physics.body()
    return Body()
end

class 'Body'

function Body:init()
    self:attribs({
            position = vec3(),
            x = 0,
            y = 0,
            z = 0,
            angle = 0,
            points = {}
        })
end

function Body:destroy()
end

class 'Fizix' : extends(Physics)

function Fizix:init()
    physics.init(self)
end

function Fizix:setArea()
end

function Fizix:add(object, ...)
    object.body = physics.body(...)
end

function Fizix:addItems()
end

function Fizix:update(dt)
end

function Fizix:draw()
end

class 'Object' : extends(Rect)

function Object:init()
    Rect.init(self)
end

function Object:addToPhysics(...)
    self.body = physics.body(...)
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
