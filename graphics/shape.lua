class 'Shape'

function Shape.setup()
    LINES = 'lines'
    CLOSE = 'close'
end

function Shape:init(shapeMode)
    self.vertices = {}
    self.vertices3d = {}

    self.shapeMode = shapeMode
    self.drawMode = nil

    self.scaleFactor = 1
end

function Shape:vertex(x, y, z)
    table.insert(self.vertices, x)
    table.insert(self.vertices, y)

    if z then
        table.insert(self.vertices3d, {x, y, z, __stroke():unpack()})
        table.insert(self.vertices3d, {0, 0, 0})
    end
end

function Shape:scale(scaleFactor)
    self.scaleFactor = scaleFactor
end

function Shape:setDrawMode(drawMode)
    self.drawMode = drawMode
end

local format = {
    {"VertexPosition", "float", 3}, -- The x,y,z position of each vertex.
}

function Shape:draw()
    if #self.vertices == 0 then return end

    pushMatrix()
    scale(self.scaleFactor, self.scaleFactor)

    if #self.vertices3d > 0 then
        local mesh = Mesh(self.vertices3d)
        self.drawMode = 'strip'
        mesh.shader = shaders.default
        mesh:draw()

    else

        if self.shapeMode == LINES then
            lines(self.vertices)

        elseif self.shapeMode == nil then
            if self.drawMode == CLOSE then
                polygon(self.vertices)
            else
                polyline(self.vertices)
            end
        end
    end
    
    popMatrix()
end
