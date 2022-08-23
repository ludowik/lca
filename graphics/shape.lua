class 'Shape'

function Shape.setup()
    LINES = 'lines'
    CLOSE = 'close'
end

function Shape:init()
    self.vertices = {}
    self.mode = CLOSE
    self.scale = 1
end

function Shape:vertex(x, y)
    table.insert(self.vertices, x)
    table.insert(self.vertices, y)
end

function Shape:scale(scale)
    self.scale = scale
end

function Shape:draw(mode)
    if #self.vertices == 0 then return end

    pushMatrix()
    scale(self.scale, self.scale)
    
    mode = mode or self.mode
    if mode == LINES then
        lines(self.vertices)
    else
        polyline(self.vertices)
    end

    popMatrix()
end
