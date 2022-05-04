class 'Body'

function Body:init(shapeType, ...)
    self.shapeType = shapeType

    self.x, self.y = 0, 0
    self.position = vec2(self.x, self.y)

    self.radius = 0
    self.points = table()

    self.angle = 0    

    if shapeType == CIRCLE then
        self.radius = ...

    elseif shapeType == POLYGON then
        local t = table{...}
        if t[1].x then
            self.points = t
        else
            self.points = ...
        end
    end

    self.linearVelocity = vec2()
end

function Body:destroy()
end

function Body:update(dt)
end

function Body:applyLinearImpulse(ix, iy)
end

function Body:testPoint(x, y)
    return false
end
