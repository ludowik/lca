class 'Shape'

function Shape:init()
    self.vertices = {}
end

function Shape:vertex(x, y)
    table.insert(self.vertices, x)
    table.insert(self.vertices, y)
end

function Shape:draw()
    polyline(self.vertices)
end
