class 'Object' : extends(Rect)

function Object:init(label, x, y, vx, vy)
    Rect.init(self)
    
    self.label = label
    
    self.state = "active"
    
    self.size = vec2()
    
    self.position = vec2(x, y)  
    self.linearVelocity = vec2(vx, vy)
    
    self.angle = 0
    self.angularVelocity = 0
end

function Object:destroy()
end

function Object:update(dt)
    self.position = self.position + self.linearVelocity * dt
    
    self.angle = self.angle + self.angularVelocity * dt
    
    if self.position.y < -H or self.position.y > H*2 then
        self.state = "dead"
    end
    
    if self.deltaTime then
        self.deltaTime = self.deltaTime + dt
    end
    
    if self.delay then
        self.delay = self.delay - dt
        if self.delay < 0 then
            self.state = "dead"
        end
    end
    
    if self.target and self.offset then
        self.linearVelocity = (self.target - self.offset - self.position) * 10
    end
    
    self.fixedSize = nil
    self.gridSize = nil
end

function Object:setFixedSize(x, y)
    x = x or ws()
    y = y or hs()

    self.fixedSize = vec2(x, y)
    return self
end

function Object:setGridSize(i, j)
    i = i or 1
    j = j or 1

    self.gridSize = vec2(i, j)
    return self
end

Object2D  = Object
Object3D  = Object

class('CircleObject', Object)

function CircleObject:init(x, y, radius)
    Object.init(self)

    self.position:set(x, y)
    self.radius = radius
    self.shapeType = CIRCLE
end

function CircleObject:addToPhysics(bodyType)
    return fizix:add(self, bodyType or DYNAMIC, self.shapeType, self.radius)
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
    return fizix:add(self, bodyType or DYNAMIC, self.shapeType, {
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
    return app.fizix:add(self, bodyType or DYNAMIC, self.shapeType, self.vertices)
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
    return app.fizix:add(self, bodyType or DYNAMIC, self.shapeType, self.radius)
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
