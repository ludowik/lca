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
