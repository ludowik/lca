local __cos, __sin, __degrees, __radians, __atan2, __sqrt = math.cos, math.sin, math.deg, math.rad, math.atan2, math.sqrt

vec2 = class()

function vec2.setup()
    ffi = require 'ffi'

    ffi.cdef [[
        typedef union vec2 {
            struct {
                float x;
                float y;
            };
            struct {
                float w;
                float h;
            };
            float values[2];
        } vec2;
    ]]

    __vec2 = ffi.metatype('vec2', vec2)
end

function vec2:init(x, y)
    self = __vec2()
    if type(x) == 'cdata' then
        self.x = x.x
        self.y = x.y
    else
        self.x = x or 0
        self.y = y or x or 0
    end
    return self
end

function vec2:set(x, y)
    self.x = x or 0
    self.y = y or x or 0
end    

function vec2:clone()
    return vec2(self.x, self.y)
end

function vec2:copy(v)
    self.x = v.x
    self.y = v.y
end

function vec2.random(w, h)
    return vec2(random(w), random(h or w))
end

function vec2:__tostring()
    return '('..self.x..','..self.y..')'
end

function vec2:normalize(coef)
    return self:clone():normalizeInPlace(coef)
end

function vec2:normalizeInPlace(coef)
    coef = coef or 1

    local len = self:len()
    if len > 0 then
        self.x = self.x * coef / len
        self.y = self.y * coef / len
    end

    return self
end

function vec2:len()
    return __sqrt(
        self.x^2 +
        self.y^2)
end

function vec2:lenSquared()
    return (
        self.x^2 +
        self.y^2)
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

function vec2:__mul(coef)
    if type(self) == 'number' then
        self, coef = coef, self
    end
    return vec2(
        self.x * coef,
        self.y * coef)
end

function vec2:dist(v)
    return __sqrt(
        (v.x - self.x)^2 +
        (v.y - self.y)^2)
end

function vec2:dot(v)
    return (
        self.x * v.x +
        self.y * v.y
    )
end

function vec2:angleBetween(other)
    local alpha1 = __atan2(self.y, self.x)
    local alpha2 = __atan2(other.y, other.x)

    return alpha2 - alpha1
end

function vec2:rotate(phi, origin, mode)
    return self:clone():rotateInPlace(phi, origin, mode)
end

function vec2:rotateInPlace(phi, origin, mode)
    local c, s

    mode = mode or angleMode()    
    if mode == DEGREES then
        c, s = __cos(__radians(phi)), __sin(__radians(phi))
    else
        c, s = __cos(phi), __sin(phi)
    end

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

function vec2.test()
end
