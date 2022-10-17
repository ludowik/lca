class 'Shape'

function Shape.setup()
    LINES = 'lines'
    CLOSE = 'close'
end

function Shape:init(shapeMode)
    self.vertices = {}
    self.shapeMode = shapeMode
    self.drawMode = nil
    self.scaleFactor = 1
end

function Shape:vertex(x, y, z)
    table.insert(self.vertices, x)
    table.insert(self.vertices, y)
end

function Shape:scale(scaleFactor)
    self.scaleFactor = scaleFactor
end

function Shape:setDrawMode(drawMode)
    self.drawMode = drawMode
end

function Shape:draw()
    if #self.vertices == 0 then return end

    pushMatrix()
    scale(self.scaleFactor, self.scaleFactor)

    if self.shapeMode == LINES then
        lines(self.vertices)

    elseif self.shapeMode == nil then
        if self.drawMode == CLOSE then
            polygon(self.vertices)
        else
            polyline(self.vertices)
        end
    end

    popMatrix()
end
