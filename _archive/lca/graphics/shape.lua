class 'Shape'

function Shape:init()
    self.vertices = Buffer('vec3')
end

function Shape:draw()
    if self.mode == LINES then
        for i=1,#self.vertices-1,2 do
            line(self.vertices[i].x, self.vertices[i].y, self.vertices[i+1].x, self.vertices[i+1].y)
        end
            
    elseif self.mode == CLOSE then
        polygon(self.vertices)
    
    else
        polyline(self.vertices)
    end
end

CLOSE = 'close'
LINES = 'lines'

local shape

function beginShape()
    shape = Shape()
end

local v = vec3()
function vertex(x, y, z)
    v.x = x
    v.y = y
    v.z = z or 0
    
    shape.vertices[#shape.vertices+1] = v:clone()
end

function scaleShape(n)
    for i=1,#shape.vertices do
        shape.vertices[i]:mul(n)
    end
end

function endShape(mode)
    shape.mode = mode
    shape:draw()
    
    return shape
end
