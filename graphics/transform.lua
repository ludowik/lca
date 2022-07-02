local __tan, __atan, __rad, __deg, __sqrt, __cos, __sin = math.tan, math.atan, math.rad, math.deg, math.sqrt, math.cos, math.sin
local love2d = love

local model_matrices = {}
local view_matrices = {}
local projection_matrices = {}

local model, view, projection

local function setTransformation()
--    if config.renderer == 'love' or config.renderer == 'core' then
        love.graphics.replaceTransform(pvmMatrix())
--    else
--        if shaders['shader3D'] then
--            pushMatrix()
--            scale_matrix(projection, 2/W, 2/H, 1)
--            translate_matrix(projection, -W/2, -H/2, 1)
--            shaders['shader3D']:send('pvm', {
--                    pvmMatrix():getMatrix()
--                })
--            model = table.remove(matrices)
--        end
--    end
end

local function setMatrix(m, mode, ...)
    m:setMatrix(mode or 'row', ...)
end

function pvMatrix()
    return projection * view
end

function pvmMatrix()
    return projection * view * model
end

function matrix()
    return love.math.newTransform()
end

function modelMatrix(m)
    if m then 
        model = m:clone()
        setTransformation()
    end
    return model
end

function viewMatrix(m)
    if m then 
        view = m:clone()
        setTransformation()
    end
    return view
end

function matByVector(m, v)
    local vm = love.math.newTransform()
    setMatrix(vm, nil,
        v.x,0,0,0,
        v.y,0,0,0,
        v.z,0,0,0,
        1,0,0,0)

    local res = m * vm
    local values = {
        res:getMatrix()
    }
    return vec4(values[1], values[5], values[9], values[13])
end

function projectionMatrix(m)
    if m then 
        projection = m:clone()
        setTransformation()
    end
    return projection
end

function resetMatrix(resetAll)
    model = love.math.newTransform()

    if resetAll then
        view = love.math.newTransform()
        projection = love.math.newTransform()
    end

    setTransformation()
end

function pushMatrix(all)
    table.insert(model_matrices, model)
    model = model:clone()
    
    if all then
        table.insert(view_matrices, view)
        view = view:clone()
        
        table.insert(projection_matrices, projection)
        projection = projection:clone()
    end
    
    --    setTransformation()
end

function popMatrix(all)
    model = table.remove(model_matrices)
    
    if all then
        view = table.remove(view_matrices)        
        projection = table.remove(projection_matrices)
    end
    
    setTransformation()
end

function translate(x, y, z)
    translate_matrix(model, x, y, z)    
    setTransformation()
end

function translate_matrix(m, x, y, z)
    assert(x)
    y = y or x
    z = z or 0

    local translate = love.math.newTransform()
    setMatrix(translate, nil,
        1,0,0,x,
        0,1,0,y,
        0,0,1,z or 0,
        0,0,0,1)
    m:apply(translate)
end

function scale(w, h, d)
    scale_matrix(model, w, h, d)
    setTransformation()
end

function scale_matrix(m, w, h, d)
    assert(w)
    h = h or w
    d = d or 1

    local scale = love.math.newTransform()
    setMatrix(scale, nil,
        w,0,0,0,
        0,h,0,0,
        0,0,d,0,
        0,0,0,1)
    m:apply(scale)
end

function rotate(angle, x, y, z)
    rotate_matrix(model, angle, x, y, z)
    setTransformation()
end

function rotate_matrix(m, angle, x, y, z)
    x = x or 0
    y = y or 0
    z = z or 1

    local c, s = __cos(angle), __sin(angle)

    if x == 1 then
        local m = love.math.newTransform()
        setMatrix(m, nil,
            1,0,0,0,
            0,c,-s,0,
            0,s,c,0,
            0,0,0,1)
        model:apply(m)
    end

    if y == 1 then
        local m = love.math.newTransform()
        setMatrix(m, nil,
            c,0,s,0,
            0,1,0,0,
            -s,0,c,0,
            0,0,0,1)
        model:apply(m)

    end

    if z == 1 then -- default
        local m = love.math.newTransform()
        setMatrix(m, nil,
            c,-s,0,0,
            s,c,0,0,
            0,0,1,0,
            0,0,0,1)
        model:apply(m)
    end    
end

function ortho(left, right, bottom, top, near, far)
    local l = left or 0
    local r = right or W or 400

    local b = bottom or 0
    local t = top or H or 400

    local n = near or -1000
    local f = far or 1000

    setMatrix(projection, nil,
        2/(r-l), 0, 0, -(r+l)/(r-l),
        0, 2/(t-b), 0, -(t+b)/(t-b),
        0, 0, -2/(f-n), -(f+n)/(f-n),
        0, 0, 0, 1)

    setTransformation()
end

function ortho3D()
    isometric(10)
end

function isometric(n)
    ortho()

    translate_matrix(projection, W/2, H/2)

    local alpha = __deg(__atan(1/__sqrt(2)))
    local beta = 45

    rotate_matrix(projection, alpha, 1, 0, 0)
    rotate_matrix(projection, beta, 0, 1, 0)

    if n then
        scale_matrix(projection, n, n, n)
    end

    setTransformation()
end

function perspective(fovy, width, height, near, far)
    local camera = getCamera()
    if camera then
        fovy = camera.fovy or fovy or 45
    else
        fovy = fovy or 45
    end

    local w = width or W or 400
    local h = height or H or 400

    local aspect = aspect or (w / h)

    near = near or 0.1
    far = far or 100000

    local range = __tan(__rad(fovy*0.5)) * near

    local left = -range * aspect
    local right = range * aspect

    local bottom = -range
    local top = range

    setMatrix(projection, nil,
        (2 * near) / (right - left), 0, (right + left)/(right - left), 0,
        0, (2 * near) / (top - bottom), (top + bottom)/(top - bottom), 0,
        0, 0, - (far + near) / (far - near), - (2 * far * near) / (far - near),
        0, 0, - 1, 0)

    setTransformation()
end

function lookAt(eye, target, up)
    eye = eye or vec3()    
    target = target or vec3()
    up = up or vec3(0, 1, 0)

    local f = (target - eye):normalize()
    local s = f:cross(up):normalize()
    local u = s:cross(f)

    view = love.math.newTransform()
    setMatrix(view, nil,
        s.x, s.y, s.z, -s:dot(eye),
        u.x, u.y, u.z, -u:dot(eye),
        -f.x, -f.y, -f.z, f:dot(eye),
        0, 0, 0, 1)

    setTransformation()
end

function camera(eye_x, eye_y, eye_z, at_x, at_y, at_z, up_x, up_y, up_z)
    _G.env.__camera = Camera(eye_x, eye_y, eye_z, at_x, at_y, at_z, up_x, up_y, up_z)
    return _G.env.__camera
end
