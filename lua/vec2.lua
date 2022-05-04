class 'vec2'

local __sqrt = math.sqrt

function vec2:init(x, y)
    self.x = x or 0
    self.y = y or 0
end

function vec2.random(w, h)
    return vec2(
        random(w),
        random(h))
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

    local len = self:len()
    if len == 0 then return vec2() end

    local invlen = 1 / len
    return vec2(
        norm * self.x * invlen,
        norm * self.y * invlen)
end

function vec2:rotate(phi, origin)
    local c, s = __cos(phi), __sin(phi)

    if origin then
        self:sub(origin)
    end

    local x, y
    x = c * self.x - s * self.y
    y = s * self.x + c * self.y

    self.x = x
    self.y = y

    if origin then
        self:add(origin)
    end

    return self
end

function vec2:angleBetween(other)
    local alpha1 = __atan2(self.y, self.x)
    local alpha2 = __atan2(other.y, other.x)

    return alpha2 - alpha1
end

function vec2.fx(p1, p2)
    local dx, dy = p2.x - p1.x, p2.y - p1.y
    if dx == 0 then
        return p2.x, 0
    end
    local a = dy / dx
    local b = p2.y - (a * p2.x)
    return a, b
end

function vec2.intersection(line1, line2)
    local a1, b1 = vec2.fx(line1[1], line1[2])
    local a2, b2 = vec2.fx(line2[1], line2[2])
    
    x = (b2 - b1) / (a1 - a2)
    y = a1 * x + b1
    
    return x, y
end
