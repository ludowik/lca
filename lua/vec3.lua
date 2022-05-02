class 'vec3'

function vec3:init(x, y, z)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
end

function vec3:__tostring()
    return self.x .. ',' .. self.y .. ',' .. self.z
end

function vec3:__add(v)
    return vec3(
        self.x + v.x,
        self.y + v.y,
        self.z + v.z)
end

function vec3:__sub(v)
    return vec3(
        self.x - v.x,
        self.y - v.y,
        self.z - v.z)
end

function vec3:len()
    return math.sqrt(
        self.x^2 +
        self.y^2 +
        self.z^2)
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

function vec3.cross(a, b)
    return vec3(
        a.y * b.z - a.z * b.y,
        a.z * b.x - a.x * b.z,
        a.x * b.y - a.y * b.x)
end

function vec3.dot(a, b)
    return (
        a.x * b.x +
        a.y * b.y +
        a.z * b.z)        
end
