class 'vec4'

local __cos, __sin, __sqrt, __atan2, __degrees = math.cos, math.sin, math.sqrt, math.atan2, math.deg

if ffi then
    ffi.cdef [[
        typedef union vec4 {
            struct {
                float x;
                float y;
                float z;
                float w;
            };
            float values[4];
        } vec4;
    ]]
end

function vec4:init(x, y, z, w)
    if type(x) == 'table' then x, y, z, w = x.x, x.y, x.z, x.w end
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.w = w or 0
end

function vec4:set(...)
    self:init(...)
    return self
end

function vec4:clone()
    return table.clone(self)
end

function vec4:__index(key)
    return rawget(vec4, key)
end

function vec4.random(w, h, d)
    if w and h and d then
        return vec4(
            randomInt(w),
            randomInt(h),
            randomInt(d),
            1)
    else
        w = w or 1
        return vec4(
            w * (random() * 2 - 1),
            w * (random() * 2 - 1),
            w * (random() * 2 - 1),
            1)
    end
end

function vec4.randomInScreen()
    local size = min(W, H)
    return vec4(
        random(size),
        random(size),
        random(size),
        1)
end

function vec4:__tostring()
    return self.x .. ',' .. self.y .. ',' .. self.z .. ',' .. self.w
end

function vec4:unpack()
    return self.x, self.y, self.z, self.w
end

function vec4:tovec3()
    return vec3(self.x, self.y, self.z)
end

function vec4:floor()
    return vec4(
        __floor(self.x),
        __floor(self.y),
        __floor(self.z),
        1)
end

function vec4.__eq(v1, v2)
    if (v1 and
        v2 and
        v1.x == v2.x and
        v1.y == v2.y and
        v1.z == v2.z and
        v1.w == v2.w)
    then
        return true
    end
end

function vec4:__unm()
    return self:clone():unm()
end

function vec4:unm()
    self.x = -self.x
    self.y = -self.y
    self.z = -self.z
    return self
end

function vec4:__add(v)
    return vec4(
        self.x + v.x,
        self.y + v.y,
        self.z + v.z,
        self.w + v.w)
end

function vec4:add(v, coef)
    coef = coef or 1
    self.x = self.x + v.x * coef
    self.y = self.y + v.y * coef
    self.z = self.z + (v.z or 0) * coef
    return self
end

function vec4:__sub(v)
    return vec4(
        self.x - v.x,
        self.y - v.y,
        self.z - v.z,
        self.w - v.w)
end

function vec4:sub(v, coef)
    coef = coef or 1
    self.x = self.x - v.x * coef
    self.y = self.y - v.y * coef
    self.z = self.z - (v.z or 0) * coef
    return self
end

function vec4:__mul(coef)
    if type(self) == 'number' then
        self, coef = coef, self
    end
    return self:clone():mul(coef)
end

function vec4:mul(coef)
    self.x = self.x * coef
    self.y = self.y * coef
    self.z = self.z * coef
    return self
end

function vec4:__div(val)
    return vec4(
        self.x / val,
        self.y / val,
        self.z / val,
        self.w / val)
end

function vec4:div(coef)
    return self:mul(1/coef)
end

function vec4:len()
    return __sqrt(
        self.x^2 +
        self.y^2 +
        self.z^2)
end

function vec4:lenSqr()
    return 
        self.x^2 +
        self.y^2 +
        self.z^2
end

function vec4:dist(v)
    return __sqrt(
        (v.x - self.x)^2 +
        (v.y - self.y)^2 +
        (v.z - self.z)^2)
end

function vec4:normalize(coef)
    return self:clone():normalizeInPlace(coef)
end

function vec4:normalizeInPlace(coef)
    coef = coef or 1

    local len = self:len()
    if len > 0 then
        self.x = self.x * coef / len
        self.y = self.y * coef / len
        self.z = self.z * coef / len
    end

    return self
end

function vec4:cross(v)
    return self:clone():crossInPlace(v)
end

function vec4:crossInPlace(v)
    local x = self.y * v.z - self.z * v.y
    local y = self.z * v.x - self.x * v.z
    local z = self.x * v.y - self.y * v.x

    self.x = x
    self.y = y
    self.z = z

    return self
end

function vec4:dot(v)
    return (
        self.x * v.x +
        self.y * v.y +
        self.z * v.z
    )
end

function xyzw(x, y, z, w, coef)
    assert(coef == nil)
    if type(x) == 'table' or type(x) == 'cdata' then
        return x.x, x.y, x.z or 0, x.w or 0, y or 1
    end
    return x or 0, y or 0, z or 0, w or 0, coef or 1
end

function vec4:draw()
    pushMatrix()
    translate(self.x, self.y, self.z)
    sphere(1)
    popMatrix()
end
