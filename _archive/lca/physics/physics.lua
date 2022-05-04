class 'Physics' : extends(table)

function Physics.setup()
    CIRCLE = 'circle'
    POLYGON = 'polygon'
    RECT = 'rect'
    CHAIN = 'chain'
    EDGE = 'edge'

    DYNAMIC = 'dynamic'
    STATIC = 'static'
    KINEMATIC = 'kinematic'

    Gravity = vec2(0, 9)
end

function Physics:init()    
    self.active = true
    self.g = Gravity
    self.bodies = table()

    self.gravity = function (g)
        self.g = g
    end

    self.pause = function ()
        self.active = false
    end

    self.resume = function ()
        self.active = true
    end

    self.setArea = function ()
    end

    self.update = function (dt)
        for i,body in ipairs(self.bodies) do
            body:update(dt)
        end
    end

    self.draw = function ()
    end

    self.body = function (shapeType, ...)
        local body = Body(shapeType, ...)
        self.bodies:add(body)
        return body
    end
end



class 'Fizix' : extends(Physics())

function Fizix:init()
    Physics.init(self)
end

function Fizix:add(object, ...)
    object.body = self.body(...)
    object.body.item = object
end

function Fizix:addItems(items, ...)
    for _,item in ipairs(items) do
        self:add(item, ...)
    end
end
