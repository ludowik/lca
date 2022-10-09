class 'Shape'

function Shape.setup()
    LINES = 'lines'
    CLOSE = 'close'
end

function Shape:init()
    self.vertices = {}
    self.mode = CLOSE
    self.scaleFactor = 1
end

function Shape:vertex(x, y)
    table.insert(self.vertices, x)
    table.insert(self.vertices, y)
end

function Shape:scale(scaleFactor)
    self.scaleFactor = scaleFactor
end

function Shape:draw(mode)
    if #self.vertices == 0 then return end

    pushMatrix()
    scale(self.scaleFactor, self.scaleFactor)
    
    mode = mode or self.mode
    if mode == LINES then
        lines(self.vertices)
    else
        polygon(self.vertices)
    end

    popMatrix()
end
