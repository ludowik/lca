function setup()
    boxes = table()
    boxes:add(Cube(0, 0, 0, 3))

    parameter.watch('#boxes')

    camera(0, 0, 10)
end

function draw()
    background()

    light(true)

    perspective()

    boxes:draw()
end

function keyboard(key)
    if key == 'return' then
        local nextBoxes = table()
        boxes:call(function (b)
                nextBoxes:addItems(b:generate())
            end)
        boxes = nextBoxes
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
        box(self.size)
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
