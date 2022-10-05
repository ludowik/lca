function setup()
    boxes = table()
    boxes:add(Cube(0, 0, 0, 1))
    
    m = Model.box()

    param = {light = true}
    parameter.watch('#boxes')
    parameter.boolean('param.light')

    camera(2, 2, 2)
end

function draw3d()
    background()

    perspective()    
    light(param.light)

--    boxes:draw()
    m:drawInstanced()
end

function keyboard(key)
    if key == 'return' then
        local nextBoxes = table()
        boxes:call(function (b)
                nextBoxes:addItems(b:generate())
            end)
        boxes = nextBoxes
        
        m.instancePosition = table()
        m.instanceScale = table()
        for i,v in ipairs(boxes) do
            m.instancePosition:add({v.position:unpack()})
            m.instanceScale:add({v.size, v.size, v.size})
        end
        m.instanceMeshPosition = nil
        m.instanceMeshScale = nil
    end
end

class('Cube')

function Cube:init(x, y, z, size)
    self.position = vec3(x, y, z)
    self.size = size
end

function Cube:draw()
    pushMatrix()
    do
        translate(self.position.x, self.position.y, self.position.z)
        box(0, 0, 0, self.size, self.size, self.size)
    end
    popMatrix()
end

function Cube:generate()
    local boxes = table()
    for x=-1,1 do
        for y=-1,1 do
            for z=-1,1 do
                local value = abs(x) + abs(y) + abs(z)
                if value > 1 then
                    local newSize = self.size / 3
                    local b = Cube(
                        self.position.x + x * newSize,
                        self.position.y + y * newSize,
                        self.position.z + z * newSize,
                        newSize)

                    boxes:add(b)
                end
            end
        end
    end
    return boxes
end
