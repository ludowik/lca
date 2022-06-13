class 'vec2'

local __cos, __sin, __sqrt, __atan2, __degrees, __round = math.cos, math.sin, math.sqrt, math.atan2, math.deg, math.round

if ffi then
    ffi.cdef [[
        typedef union vec2 {
            struct {
                float x;
                float y;
            };
            float values[2];
        } vec2;
    ]]
end

function vec2:init(x, y)
    if type(x) == 'table' then x, y = x.x, x.y end
    self.x = x or 0
    self.y = y or 0
    self.z = 0
end

function vec2:set(...)
    self:init(...)
    return self
end

function vec2:clone()
    return table.clone(self)
end

function vec2:__index(key)
    if key == 'w' then
        return self.x
    elseif key == 'h' then
        return self.y
    end
    return rawget(vec2, key)
end

function vec2.random(w, h)
    return vec2(
        random(w),
        random(h))
end

function vec2.randomInScreen()
    return vec2(
        random(W),
        random(H))
end

function vec2:__tostring()
    return self.x .. ',' .. self.y
end

function vec2:unpack()
    return self.x, self.y
end

function vec2:tovec3()
    return vec3(self.x, self.y, 0)
end

function vec2:floor()
    return vec2(
        __floor(self.x),
        __floor(self.y))
end

function vec2:round()
    return vec2(
        __round(self.x),
        __round(self.y))
end

function vec2.__eq(v1, v2)
    if (v1 and
        v2 and
        v1.x == v2.x and
        v1.y == v2.y)
    then
        return true
    end
end

function vec2:__unm()
    return self:clone():unm()
end

function vec2:unm()
    self.x = -self.x
    self.y = -self.y
    return self
end

function vec2:__add(v)
    return vec2(
        self.x + v.x,
        self.y + v.y)
end

function vec2:add(v, coef)
    coef = coef or 1
    self.x = self.x + v.x * coef
    self.y = self.y + v.y * coef
    return self
end

function vec2:__sub(v)
    return vec2(
        self.x - v.x,
        self.y - v.y)
end

function vec2:sub(v, coef)
    coef = coef or 1
    self.x = self.x - v.x * coef
    self.y = self.y - v.y * coef
    return self
end

function vec2:__mul(coef)
    if type(self) == 'number' then
        self, coef = coef, self
    end
    return vec2(
        self.x * coef,
        self.y * coef)
end

function vec2:mul(coef)
    self.x = self.x * coef
    self.y = self.y * coef
    return self
end

function vec2:__div(coef)
    local invcoef = 1 / coef
    return vec2(
        self.x * invcoef,
        self.y * invcoef)
end

function vec2:div(coef)
    local invcoef = 1 / coef
    self.x = self.x * invcoef
    self.y = self.y * invcoef
    return self
end

function vec2:len()
    return __sqrt(
        self.x^2 +
        self.y^2)
end

function vec2:lenSquared()
    return (
        self.x ^ 2 +
        self.y ^ 2)
end

function vec2:dist(v)
    return __sqrt(
        (v.x - self.x) ^ 2 +
        (v.y - self.y) ^ 2)
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

function vec2:normalizeInPlace(norm)
    norm = norm or 1

    local len = self:len()
    if len == 0 then return vec2() end

    local invlen = 1 / len

    self.x = norm * self.x * invlen
    self.y = norm * self.y * invlen

    return self
end


function vec2:crossByScalar(s)
    return vec2(s * self.y, -s * self.x)
end

function vec2:crossFromScalar(s)
    return vec2(-s * self.y, s * self.x)
end

function vec2:cross(v)
    return self:clone():crossInPlace(v)
end

function vec2:crossInPlace(v)
    local x = self.y * v.z - self.z * v.y
    local y = self.z * v.x - self.x * v.z

    self.x = x
    self.y = y

    return self
end

function vec2:rotate(phi, origin)
    local v = self:clone()
    local c, s = __cos(phi), __sin(phi)

    if origin then
        v:sub(origin)
    end

    local x, y
    x = c * v.x - s * v.y
    y = s * v.x + c * v.y

    v.x = x
    v.y = y

    if origin then
        v:add(origin)
    end

    return v
end

function vec2:rotateInPlace(phi, origin)
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

function vec2:dot(v)
    return (
        self.x * v.x +
        self.y * v.y
    )
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

    local x = (b2 - b1) / (a1 - a2)
    local y = a1 * x + b1

    return x, y
end

local ORDER = 'counter-clockwise'

function vec2.enclosedAngle(v1, v2, v3)
    local a1 = __atan2(v1.y - v2.y, v1.x - v2.x)
    local a2 = __atan2(v3.y - v2.y, v3.x - v2.x)

    local da
    if ORDER == 'clockwise' then
        da = __degrees(a2 - a1)
    else
        da = __degrees(a1 - a2)
    end

    if da < -180 then
        da = da + 360
    elseif da > 180 then
        da = da - 360
    end

    return da
end

-- Determines if a vector |v| is inside a triangle described by the vectors
-- |v1|, |v2| and |v3|.
function vec2.isInsideTriangle(v, v1, v2, v3)
    local a1
    local a2

    a1 = vec2.enclosedAngle(v1, v2, v3)
    a2 = vec2.enclosedAngle(v, v2, v3)
    if a2 > a1 or a2 < 0 then
        return false
    end

    a1 = vec2.enclosedAngle(v2, v3, v1)
    a2 = vec2.enclosedAngle(v, v3, v1)
    if a2 > a1 or a2 < 0 then
        return false
    end

    a1 = vec2.enclosedAngle(v3, v1, v2)
    a2 = vec2.enclosedAngle(v, v1, v2)
    if a2 > a1 or a2 < 0 then
        return false
    end

    return true
end

function vec2:draw()
    point(self.x, self.y)
end
