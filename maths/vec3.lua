class 'vec3'

local __cos, __sin, __sqrt, __atan2, __degrees = math.cos, math.sin, math.sqrt, math.atan2, math.deg

if ffi then
    ffi.cdef [[
        typedef union vec3 {
            struct {
                float x;
                float y;
                float z;
            };
            float values[3];
        } vec3;
    ]]

--    ffi.metatype('vec3', vec3)
end

function vec3:init(x, y, z)
--    self = ffi.new('vec3')
    
    if type(x) == 'table' or type(x) == 'cdata' then x, y, z = x.x, x.y, x.z end
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    
--    return self
end

function vec3:set(...)
    self:init(...)
    return self
end

function vec3:clone()
    return table.clone(self)
end

--function vec3:__newindex(key, value)
--    if key == 'w' then
--        self.x = value
--        return
--    elseif key == 'h' then
--        self.y = value
--        return
--    elseif key == 'd' then
--        self.z = value
--        return
--    end
--    if type(key) == 'number' then
--        if key == 1 then self.x = value end
--        if key == 2 then self.y = value end
--        if key == 3 then self.z = value end
--        return
--    end

--    return rawset(vec3, key, value)
--end

function vec3:__index(key)
    if key == 'w' then
        return self.x
    elseif key == 'h' then
        return self.y
    elseif key == 'd' then
        return self.z
    end
--    if type(key) == 'number' then
--        if key == 1 then return self.x end
--        if key == 2 then return self.y end
--        if key == 3 then return self.z end
--    end

    return rawget(vec3, key)
end

function vec3.random(w, h, d)
    w = w or 1
    h = h or w
    d = d or h

    return vec3(
        random(w),
        random(h),
        random(d))
end

function vec3.randomInScreen()
    local size = min(W, H)
    return vec3(
        random(size),
        random(size),
        random(size))
end

function vec3:__tostring()
    return self.x .. ',' .. self.y .. ',' .. self.z
end

function vec3:unpack()
    return self.x, self.y, self.z
end

function vec3:tovec3()
    return self
end

function vec3:floor()
    return vec3(
        __floor(self.x),
        __floor(self.y),
        __floor(self.z))
end

function vec3:round()
    return vec3(
        __round(self.x),
        __round(self.y),
        __round(self.z))
end

function vec3.__eq(v1, v2)
    if (v1 and
        v2 and
        v1.x == v2.x and
        v1.y == v2.y and
        v1.z == v2.z)
    then
        return true
    end
end

function vec3:__unm()
    return self:clone():unm()
end

function vec3:unm()
    self.x = -self.x
    self.y = -self.y
    self.z = -self.z
    return self
end

function vec3:__add(v)
    return vec3(
        self.x + v.x,
        self.y + v.y,
        self.z + v.z)
end

function vec3:add(v)
    self.x = self.x + v.x
    self.y = self.y + v.y
    self.z = self.z + v.z
    return self
end

function vec3:__sub(v)
    return vec3(
        self.x - v.x,
        self.y - v.y,
        self.z - v.z)
end

function vec3:sub(v)
    self.x = self.x - v.x
    self.y = self.y - v.y
    self.z = self.z - v.z
    return self
end

function vec3:__mul(coef)
    if type(self) == 'number' then
        self, coef = coef, self
    end
    return vec3(
        self.x * coef,
        self.y * coef,
        self.z * coef)
end

function vec3:mul(coef)
    self.x = self.x * coef
    self.y = self.y * coef
    self.z = self.z * coef
    return self
end

function vec3:__div(coef)
    local invcoef = 1 / coef
    return vec3(
        self.x * invcoef,
        self.y * invcoef,
        self.z * invcoef)
end

function vec3:div(coef)
    local invcoef = 1 / coef
    self.x = self.x * invcoef
    self.y = self.y * invcoef
    self.z = self.z * invcoef
    return self
end

function vec3:len()
    return __sqrt(
        self.x^2 +
        self.y^2 +
        self.z^2)
end

function vec3:lenSqr()
    return ( 
        self.x^2 +
        self.y^2 +
        self.z^2)
end

function vec3:dist(v)
    return __sqrt(
        (v.x - self.x)^2 +
        (v.y - self.y)^2 +
        (v.z - self.z)^2)
end

function vec3:normalize(norm)
    norm = norm or 1

    local len = self:len()
    if len == 0 then return vec3() end

    local invlen = 1 / len
    return vec3(
        norm * self.x * invlen,
        norm * self.y * invlen,
        norm * self.z * invlen)
end

function vec3:normalizeInPlace(norm)
    norm = norm or 1

    local len = self:len()
    if len == 0 then return vec3() end

    local invlen = 1 / len

    self.x = norm * self.x * invlen
    self.y = norm * self.y * invlen
    self.z = norm * self.z * invlen

    return self
end

function vec3.cross(a, b)
    return vec3(
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x)
end

function vec3.crossInPlace(a, b)    
    local x = a.y * b.z - a.z * b.y
    local y = a.z * b.x - a.x * b.z
    local z = a.x * b.y - a.y * b.x
    a.x, a.y, a.z = x, y, z
    return a
end

function vec3.dot(a, b)
    return (
        a.x * b.x +
        a.y * b.y +
        a.z * b.z)        
end

function xyz(x, y, z, coef)
    assert(coef == nil)
    if type(x) == 'table' or type(x) == 'cdata' then
        return x.x, x.y, x.z or 0, y or 1
    end
    return x or 0, y or 0, z or 0, coef or 1
end

function vec3:draw()
    pushMatrix()
    translate(self.x, self.y, self.z)
    sphere(1)
    popMatrix()
end
