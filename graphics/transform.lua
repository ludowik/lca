local __tan, __atan, __rad, __deg, __sqrt = math.tan, math.atan, math.rad, math.deg, math.sqrt
local love2d = love

local matrices = {}
local model, view, projection

local function setMatrix()
    love.graphics.replaceTransform(projection * view * model)
end

function resetMatrix()
--    love2d.graphics.origin()
    model = love.math.newTransform()
    view = love.math.newTransform()
    projection = love.math.newTransform()

    setMatrix()
end

function pushMatrix()
--    love2d.graphics.push()
    table.insert(matrices, model)
    model = model:clone()    
    setMatrix()
end

function popMatrix()
--    love2d.graphics.pop()
    model = table.remove(matrices)
    setMatrix()
end

function translate(x, y, z)
--    love2d.graphics.translate(x, y)
--    model:translate(x, y, z)
    
    assert(x)
    y = y or x
    z = z or 0
    
    local m = love.math.newTransform()
    m:setMatrix(
        1,0,0,x,
        0,1,0,y,
        0,0,1,z or 0,
        0,0,0,1)
    model:apply(m)
        
    setMatrix()
end

function scale(w, h, d)
--    love2d.graphics.scale(w, h)
--    model:scale(w, h, d)

    assert(w)
    h = h or w
    d = d or 0    
    
    local m = love.math.newTransform()
    m:setMatrix(
        w,0,0,0,
        0,h,0,0,
        0,0,d,0,
        0,0,0,1)
    model:apply(m)
    
    setMatrix()
end

function rotate(angle)
--    love2d.graphics.rotate(angle)
    model:rotate(angle)
    setMatrix()
end

function ortho(left, right, bottom, top, near, far)
    local l = left or 0
    local r = right or W or screen.W or 400

    local b = bottom or 0
    local t = top or H or screen.H or 400

    local n = near or -1000
    local f = far or 1000

    projection = love.math.newTransform()
    projection:setMatrix(
        2/(r-l), 0, 0, -(r+l)/(r-l),
        0, 2/(t-b), 0, -(t+b)/(t-b),
        0, 0, -2/(f-n), -(f+n)/(f-n),
        0, 0, 0, 1)
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
    projection:setMatrix(
        (2 * near) / (right - left), 0, 0, 0,
        0, (2 * near) / (top - bottom), 0, 0,
        0, 0, - (far + near) / (far - near), - (2 * far * near) / (far - near),
        0, 0, - 1, 0)

    setMatrix()
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
end

function lookAt(eye, center, up)
    eye = eye or vec3()    
    center = center or vec3()
    up = up or vec3(0, 1, 0)

    local f = (center - eye):normalize()
    local s = f:cross(up:normalize()):normalize()
    local u = s:cross(f)

    view = love.math.newTransform()
    view:setMatrix(        
        s.x, s.y, s.z, -s:dot(eye),
        u.x, u.y, u.z, -u:dot(eye),
        -f.x, -f.y, -f.z, f:dot(eye),
        0, 0, 0, 1)

    setMatrix()
end



