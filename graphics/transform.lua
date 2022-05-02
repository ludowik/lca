local __tan, __atan, __rad, __deg, __sqrt, __cos, __sin = math.tan, math.atan, math.rad, math.deg, math.sqrt, math.cos, math.sin
local love2d = love

local matrices = {}
local model, view, projection

local function setTransformation()
    love.graphics.replaceTransform(projection * view * model)
end

local function setMatrix(m, ...)
    m:setMatrix('row', ...)
end

function pvMatrix()
    return projection * view
end

function pvmMatrix()
    return (projection * view) * model
end

function modelMatrix()
    return model
end

function viewMatrix()
    return view
end

function matByVector(m, b)
    local bm = love.math.newTransform()
    setMatrix(bm,
        b.x,0,0,0,
        0,b.y,0,0,
        0,0,0,b.z,
        0,0,0,1)

    local res = m * bm
    local values = {
        res:getMatrix()
    }
    return vec4(values[1], values[5], values[9], values[13])
end

--local res, bm
--function mt:mulVector(b)
--    res = res or matrix()

--    bm = bm or matrix()
--    bm.i0 = b.x
--    bm.i4 = b.y
--    bm.i8 = b.z
--    bm.i12 = 1

--    self:__mul(bm, res)

--    return vec4(res.i0, res.i4, res.i8, res.i12)
--end

function projectionMatrix()
    return projection
end

function resetMatrix()
--    love2d.graphics.origin()
    model = love.math.newTransform()
    view = love.math.newTransform()
    projection = love.math.newTransform()

    setTransformation()
end

function pushMatrix()
--    love2d.graphics.push()
    table.insert(matrices, model)
    model = model:clone()    
    setTransformation()
end

function popMatrix()
--    love2d.graphics.pop()
    model = table.remove(matrices)
    setTransformation()
end

function translate(x, y, z)
--    love2d.graphics.translate(x, y)
--    model:translate(x, y, z)

    assert(x)
    y = y or x
    z = z or 0

    local m = love.math.newTransform()
    setMatrix(m,
        1,0,0,x,
        0,1,0,y,
        0,0,1,z or 0,
        0,0,0,1)
    model:apply(m)

    setTransformation()
end

function scale(w, h, d)
--    love2d.graphics.scale(w, h)
--    model:scale(w, h, d)

    assert(w)
    h = h or w
    d = d or 0    

    local m = love.math.newTransform()
    setMatrix(m,
        w,0,0,0,
        0,h,0,0,
        0,0,d,0,
        0,0,0,1)
    model:apply(m)

    setTransformation()
end

function rotate(angle, x, y, z)
    x = x or 0
    y = y or 0
    z = z or 1

--    love2d.graphics.rotate(angle)
--    model:rotate(angle)

    local c, s
--        mode = mode or angleMode()
--        if mode == DEGREES then
--    c, s = __cos(__rad(angle)), __sin(__rad(angle))
--        else
    c, s = __cos(angle), __sin(angle)
--        end

    if x == 1 then
        local m = love.math.newTransform()
        setMatrix(m,
            1,0,0,0,
            0,c,-s,0,
            0,s,c,0,
            0,0,0,1)
        model:apply(m)

--        m2x.i5 = c
--        m2x.i6 = -s
--        m2x.i9 = s
--        m2x.i10 = c
--        return m1:__mul(m2x, res)
end

    if y == 1 then
        local m = love.math.newTransform()
        setMatrix(m,
            c,0,s,0,
            0,1,0,0,
            -s,0,c,0,
            0,0,0,1)
        model:apply(m)

--        m2y.i0 = c
--        m2y.i2 = s
--        m2y.i8 = -s
--        m2y.i10 = c
--        return m1:__mul(m2y, res)

end

    if z == 1 then -- default
        local m = love.math.newTransform()
        setMatrix(m,
            c,-s,0,0,
            s,c,0,0,
            0,0,1,0,
            0,0,0,1)
        model:apply(m)

--        m2z.i0 = c
--        m2z.i1 = -s
--        m2z.i4 = s
--        m2z.i5 = c
--        return m1:__mul(m2z, res)

    end

    setTransformation()
end

function ortho(left, right, bottom, top, near, far)
    local l = left or 0
    local r = right or W or screen.W or 400

    local b = bottom or 0
    local t = top or H or screen.H or 400

    local n = near or -1000
    local f = far or 1000

    projection = love.math.newTransform()
    setMatrix(projection,
        2/(r-l), 0, 0, -(r+l)/(r-l),
        0, 2/(t-b), 0, -(t+b)/(t-b),
        0, 0, -2/(f-n), -(f+n)/(f-n),
        0, 0, 0, 1)

    setTransformation()
end

function isometric(n)
    ortho()

    translate(W/2, H/2)

    local alpha = __deg(__atan(1/__sqrt(2)))
    local beta = 45

    rotate(alpha, 1, 0, 0)
    rotate(beta, 0, 1, 0)

    if n then
        scale(n, n, n)
    end

    setTransformation()
end

function perspective(fov, width, height, zNear, zFar)
    local camera = nil -- getCamera()
    if camera then
        fovy = camera.fovy or fovy or 45
    else
        fovy = fovy or 45
    end

    local w = W or screen.W or 400
    local h = H or screen.H or 400

    aspect = aspect or (w / h)

    near = near or 0.1
    far = far or 100000

    local range = __tan(__rad(fovy*0.5)) * near

    local left = -range * aspect
    local right = range * aspect

    local bottom = -range
    local top = range

    projection = love.math.newTransform()
    setMatrix(projection,
        (2 * near) / (right - left), 0, 0, 0,
        0, (2 * near) / (top - bottom), 0, 0,
        0, 0, - (far + near) / (far - near), - (2 * far * near) / (far - near),
        0, 0, - 1, 0)

    setTransformation()
end

function lookAt(eye, center, up)
    eye = eye or vec3()    
    center = center or vec3()
    up = up or vec3(0, 1, 0)

    local f = (center - eye):normalize()
    local s = f:cross(up:normalize()):normalize()
    local u = s:cross(f)

    view = love.math.newTransform()
    setMatrix(view,
        s.x, s.y, s.z, -s:dot(eye),
        u.x, u.y, u.z, -u:dot(eye),
        -f.x, -f.y, -f.z, f:dot(eye),
        0, 0, 0, 1)

    setTransformation()
end
