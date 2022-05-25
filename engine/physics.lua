physics = class 'Physics'

function physics.setup()
    SPHERE = 'sphere'
    POLYGON = 'polygon'

    STATIC = 'static'
    DYNAMIC = 'dynamic'

    Gravity = vec2()
end

function physics.gravity(g)
    physics.g = g or physics.g
end

function physics.resume()
end

function physics.body()
    return {
        x = 0,
        y = 0,
        angle = 0,
        points = {}
    }
end

class 'Fizix' : extends(Physics)

function Fizix:setArea()
end

function Fizix:add()
end

function Fizix:addItems()
end

function Fizix:update(dt)
end

function Fizix:draw()
end

class 'Object2D'

function Object2D:setPosition()
end

function Object2D:update(dt)
end

class 'Object3D'

function Object3D:setPosition()
end

function Object3D:update(dt)
end
