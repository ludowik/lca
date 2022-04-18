class 'Color'

function Color:init(r, g, b, a)
    self.r = r or 0
    self.g = g or r
    self.b = b or r
    self.a = a or 1
end

function Color:unpack()
    return self.r, self.g, self.b, self.a
end

function Color.setup()
    colors = {
        white = Color(1, 1, 1),
        black = Color(0, 0, 0),
        
        gray = Color(0.5, 0.5, 0.5),
        
        red = Color(1, 0, 0),
        green = Color(0, 1, 0),
        blue = Color(0, 0, 1),
    }
end
