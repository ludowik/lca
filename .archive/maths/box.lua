class 'Box' : extends(Rect)

function Box:init(x, y, z, w, h, d)
    self.position = vec3(x, y, z)
    self.size = vec3(w, h, d)

    self.absolutePosition = self.position:clone()

    self.rotation = 0
end

function Box.random(w, h, d, size)
    return Box(
        random(w),
        random(h),
        random(d),
        random(size or 100),
        random(size or 100),
        random(size or 100))
end

function Box:z1()
    local dz = self.alignMode == CENTER and (self.size.d / 2) or 0
    return self.absolutePosition.z - dz
end

function Box:z2()
    local dz = self.alignMode == CENTER and (self.size.d / 2) or 0
    return self.absolutePosition.z + self.size.d - dz
end

function Box:zc()
    local zx = self.alignMode == CENTER and 0 or (self.size.d / 2)
    return self.absolutePosition.z + dz
end

function Box:zmin()
    return min(self:z1(), self:z2())
end

function Box:zmax()
    return max(self:z1(), self:z2())
end

function Box:draw()
    box(self.position.x, self.position.y, self.position.z, self.size.w, self.size.g, self.size.d)
end

function Box:intersect(cube)
    return cubeIntersectCube(self, cube)
end
