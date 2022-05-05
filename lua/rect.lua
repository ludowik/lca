Rect = class()

function Rect:init(x, y, w, h)
    self.position = vec2(x, y)
    self.size = vec2(w, h)
end

function Rect.random(w, h)
    return Rect(
        random(w),
        random(h or w),
        random(w),
        random(h or w))
end

function Rect:__tostring()
    return tostring(self.position)..','..tostring(self.size)
end

function Rect:contains(x, y)
    if type(x) == 'table' or type(x) == 'cdata' then x, y = x.x, x.y end
    assert(type(x) == 'number')

    return (
        self.position.x <= x and x <= self.position.x + self.size.x and
        self.position.y <= y and y <= self.position.y + self.size.y
    )
end

function Rect:w()
    return self.size.w
end

function Rect:h()
    return self.size.h
end

function Rect:fx()
    local w, h = self:w(), self:h()
    if w == 0 then
        return self.position.x, nil
    end
    local a = h / w
    local b = self:y2() - (a * self:x2())
    return a, b
end

function Rect.test()
end
