class 'Rect' : extends(table)

function Rect:init(x, y, w, h)
    self.position = vec2(x, y)
    self.size = vec2(w, h)
    
    self.absolutePosition = self.position:clone()

    self.rotation = 0
end

function Rect.random(w, h, size)
    return Rect(
        random(w),
        random(h),
        random(size or 10),
        random(size or 10))
end

function Rect:draw()
    rectMode(self.alignMode or CORNER)
    rect(self.position.x, self.position.y, self.size.x, self.size.y)
end

function Rect:setPosition(x, y)
    if y == nil then
        x, y = x.x, x.y
    end

    self.position.x = x
    self.position.y = y

    return self
end

function Rect:setSize(w, h)
    if h == nil then
        w, h = w.x, w.y
    end

    self.size.x = w
    self.size.y = h

    return self
end

function Rect:contains(x, y)
    if type(x) == 'table' or type(x) == 'cdata' then x, y = x.x, x.y end
    assert(type(x) == 'number')

    return (
        self.position.x <= x and x <= self.position.x + self.size.w and
        self.position.y <= y and y <= self.position.y + self.size.h
    )
end

function Rect:intersect(rect)
    return AABBintersectAABB(self, rect)
end

function Rect:w()
    return self.size.x
end

function Rect:h()
    return self.size.y
end

function Rect:x1()
    local dx = self.alignMode == CENTER and (self.size.x / 2) or 0
    return self.absolutePosition.x - dx
end

function Rect:x2()
    local dx = self.alignMode == CENTER and (self.size.x / 2) or 0
    return self.absolutePosition.x + self.size.x - dx
end

function Rect:y1()
    local dy = self.alignMode == CENTER and (self.size.y / 2) or 0
    return self.absolutePosition.y - dy
end

function Rect:y2()
    local dy = self.alignMode == CENTER and (self.size.y / 2) or 0
    return self.absolutePosition.y + self.size.y - dy
end

function Rect:xc()
    local dx = self.alignMode == CENTER and 0 or (self.size.x / 2)
    return self.absolutePosition.x + dx
end

function Rect:yc()
    local dy = self.alignMode == CENTER and 0 or (self.size.y / 2)
    return self.absolutePosition.y + dy
end

function Rect:xmin()
    return min(self:x1(), self:x2())
end

function Rect:xmax()
    return max(self:x1(), self:x2())
end

function Rect:ymin()
    return min(self:y1(), self:y2())
end

function Rect:ymax()
    return max(self:y1(), self:y2())
end

function Rect:leftBottom()
    return vec2(
        min(self:x1(), self:x2()),
        min(self:y1(), self:y2()))
end

function Rect:leftTop()
    return vec2(
        min(self:x1(), self:x2()),
        max(self:y1(), self:y2()))
end

function Rect:rightBottom()
    return vec2(
        max(self:x1(), self:x2()),
        min(self:y1(), self:y2()))
end

function Rect:rightTop()
    return vec2(
        max(self:x1(), self:x2()),
        max(self:y1(), self:y2()))
end

function Rect:center()
    return vec2(
        self:xc(),
        self:yc())
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
