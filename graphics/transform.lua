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
    model:translate(x, y, z)
    setMatrix()
end

function scale(w, h, d)
--    love2d.graphics.scale(w, h)
    model:scale(w, h, d)
    setMatrix()
end

function rotate(angle)
--    love2d.graphics.rotate(angle)
    model:rotate(angle)
    setMatrix()
end

function perspective(fov, width, height, zNear, zFar)
    fov = fov or rad(45)

    width = width or W
    height = height or H

    zNear = 0
    zFar = 1000

    local rad = fov
    local h = cos(0.5 * rad) / sin(0.5 * rad)
    local w = h * height / width

    projection = love.math.newTransform()

    projection:setMatrix(
        w, 0, 0, 0,
        0, h, 0, 0,
        0, 0, - (zFar + zNear) / (zFar - zNear), -1,
        0, 0, - (2 * zFar * zNear) / (zFar - zNear), 0)

    setMatrix()
end

function lookAt(eye, center, up)
    eye = eye or vec3()
    center = center or vec3()
    up = up or vec3(0, 1, 0)
    
    local f = (center - eye):normalize()
    local s = f:cross(up):normalize()
    local u = s:cross(f)

    view = love.math.newTransform()

    view:setMatrix(
        s.x, s.y, s.z, 0,
        u.x, u.y, u.z, 0,
        -f.x, -f.y, -f.z, 0,
        -s:dot(eye), -u:dot(eye), f:dot(eye), 1)

    setMatrix()
end
