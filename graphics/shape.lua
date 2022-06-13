class 'Shape'

function Shape.setup()
    LINES = 'lines'
    CLOSE = 'close'
end

function Shape:init()
    self.vertices = {}
    self.mode = CLOSE
end

function Shape:vertex(x, y)
    table.insert(self.vertices, x)
    table.insert(self.vertices, y)
end

function Shape:scale(n)
    self.n = n
end

function Shape:draw(mode)
    if #self.vertices == 0 then return end

    if self.n then
        pushMatrix()
        scale(self.n, self.n)
    end

    mode = mode or self.mode
    if mode == LINES then
        lines(self.vertices)
    else
        polyline(self.vertices)
    end

    if self.n then
        popMatrix()
    end
end
