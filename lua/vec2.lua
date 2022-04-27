class 'vec2'

local __sqrt = math.sqrt

function vec2:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

function vec2:__tostring()
    return self.x .. ',' .. self.y
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
    return __sqrt(
        self.x^2 +
        self.y^2)
end

function vec2:lenSquared()
    return self.x ^ 2 + self.y ^ 2
end

function vec2:dist(v)
    return __sqrt((v.x - self.x) ^ 2 + (v.y - self.y) ^ 2)
end

function vec2:normalize(norm)
    norm = norm or 1
    
    local invlen = 1 / self:len()
    return vec2(
        norm * self.x * invlen,
        norm * self.y * invlen)
end
