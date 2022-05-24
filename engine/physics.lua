physics = class 'Physics'

POLYGON = 'polygon'
DYNAMIC = 'dynamic'
STATIC = 'static'

Gravity = vec2()

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

function Fizix:add()
end

class 'Object2D'

function Object2D:setPosition()
end

