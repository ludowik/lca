class 'vec3'

function vec3:init(x, y, z)
    if type(x) == 'table' then x, y, z = x.x, x.y, x.z end
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
end

function vec3:set(...)
    self:init(...)
    return self
end

function vec3:clone()
    return table.clone(self)
end

function vec3:__index(key)
    if key == 'w' then
        return self.x
    elseif key == 'h' then
        return self.y
    elseif key == 'd' then
        return self.z
    end
    return rawget(vec3, key)
end

function vec3.random(w, h, d)
    return vec3(
        random(w),
        random(h),
        random(d))
end

function vec3:__tostring()
    return self.x .. ',' .. self.y .. ',' .. self.z
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

function vec3:len()
    return math.sqrt(
        self.x^2 +
        self.y^2 +
        self.z^2)
end

function vec3:__div(coef)
    local invcoef = 1 / coef
    return vec2(
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
    a.x = a.y * b.z - a.z * b.y
    a.y = a.z * b.x - a.x * b.z
    a.z = a.x * b.y - a.y * b.x
    return a
end

function vec3.dot(a, b)
    return (
        a.x * b.x +
        a.y * b.y +
        a.z * b.z)        
end

function vec3:draw()
    pushMatrix()
    translate(self.x, self.y, self.z)
    sphere(1)
    popMatrix()
end