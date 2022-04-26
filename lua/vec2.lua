class 'vec2'

function vec2:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

function vec2:__add(v)
    return vec2(
        self.x + v.x,
        self.y + v.y)
end

function vec2:__sub(v)
    return vec2(
        self.x - v.x,
        self.y - v.y)
end

function vec2:len()
    return math.sqrt(
        self.x^2 +
        self.y^2)
end

function vec2:normalize(norm)
    norm = norm or 1
    
    local invlen = 1 / self:len()
    return vec2(
        norm * self.x * invlen,
        norm * self.y * invlen)
end
