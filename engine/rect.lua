class 'Rect'

function Rect:init(x, y, w, h)
    assert(x, y, w, h)
    
    self.x = x
    self.y = y
    self.w = w
    self.h = h
end

function Rect:contains(x, y)
    return (
        self.x <= x and x <= self.x + self.w and
        self.y <= y and y <= self.y + self.h
    )
end
