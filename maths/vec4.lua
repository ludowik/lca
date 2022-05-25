class 'vec4'

function vec4:init(x, y, z, w)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
    self.w = w or 0
end

function vec4:__tostring()
    return self.x .. ',' .. self.y .. ',' .. self.z .. ',' .. self.w
end

function vec4:unpack()
    return self.x, self.y, self.z, self.w
end

function xyzw(x, y, z, w, coef)
    assert(coef == nil)
    if type(x) == 'table' or type(x) == 'cdata' then
        return x.x, x.y, x.z or 0, x.w or 0, y or 1
    end
    return x or 0, y or 0, z or 0, w or 0, coef or 1
end

function vec4:__add(v)
    return vec4(
        self.x + v.x,
        self.y + v.y,
        self.z + v.z,
        self.w + v.w)
end

function vec4:__sub(v)
    return vec4(
        self.x - v.x,
        self.y - v.y,
        self.z - v.z,
        self.w - v.w)
end

function vec4:__div(val)
    return vec4(
        self.x / val,
        self.y / val,
        self.z / val,
        self.w / val)
end

function vec4:draw()
    pushMatrix()
    translate(self.x, self.y, self.z)
    sphere(1)
    popMatrix()
end
