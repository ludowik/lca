local __degrees, __tan, __atan, __rad = math.deg, math.tan, math.atan, math.rad

class ('Transform')

function Transform.setup()
    resetMatrix(true)
end

function resetMatrix(all)
    __modelMatrix = matrix()

    if all then
        __projectionMatrix = matrix()
        __viewMatrix = matrix()

        __pvMatrix = matrix()

        ortho()
    end
end

function pushMatrix()
    push('__projectionMatrix', __projectionMatrix)
    push('__viewMatrix', __viewMatrix)
    push('__modelMatrix', __modelMatrix)
    push('__pvMatrix', __pvMatrix)
    push('__pvmMatrix', __pvmMatrix)
end

function popMatrix()
    __projectionMatrix = pop('__projectionMatrix')
    __viewMatrix = pop('__viewMatrix')
    __modelMatrix = pop('__modelMatrix')
    __pvMatrix = pop('__pvMatrix')
    __pvmMatrix = pop('__pvmMatrix')
end

function pvMatrix()
    return __pvMatrix
end

function pvmMatrix()
    return __pvmMatrix
end

function projectionMatrix(m)
    if m then
        __projectionMatrix = m

        __pvMatrix = __projectionMatrix * __viewMatrix
        __pvmMatrix = __pvMatrix * __modelMatrix
    end
    return __projectionMatrix
end

function viewMatrix(m)
    if m then
        __viewMatrix = m

        __pvMatrix = __projectionMatrix * __viewMatrix
        __pvmMatrix = __pvMatrix * __modelMatrix
    end
    return __viewMatrix
end

function modelMatrix(m)
    if m then
        __modelMatrix = m
        __pvmMatrix = __pvMatrix * __modelMatrix
    end
    return __modelMatrix
end

function translate(x, y, z)
    __modelMatrix = __modelMatrix:translate(x, y, z)
end

function scale(sx, sy, sz)
    __modelMatrix = __modelMatrix:scale(sx, sy, sz)
end

function rotate(angle, x, y, z, mode)
    __modelMatrix = __modelMatrix:rotate(angle, x, y, z, nil, mode)
end

function rotateX(angle)
    return rotate(angle, 1, 0, 0)
end

function rotateY(angle)
    return rotate(angle, 0, 1, 0)
end

function rotateZ(angle)
    return rotate(angle, 0, 0, 1)
end

function ortho(left, right, bottom, top, near, far)
    local l = left or 0
    local r = right or W or screen.W or 400

    local b = bottom or 0
    local t = top or H or screen.H or 400

    local n = near or -1000
    local f = far or 1000

    projectionMatrix(matrix(
            2/(r-l), 0, 0, -(r+l)/(r-l),
            0, 2/(t-b), 0, -(t+b)/(t-b),
            0, 0, -2/(f-n), -(f+n)/(f-n),
            0, 0, 0, 1))
end

function perspective(fovy, aspect, near, far)
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

    projectionMatrix(matrix(
            (2 * near) / (right - left), 0, 0, 0,
            0, (2 * near) / (top - bottom), 0, 0,
            0, 0, - (far + near) / (far - near), - (2 * far * near) / (far - near),
            0, 0, - 1, 0))
end

function isometric(n)
    ortho()

    translate(W/2, H/2)

    local alpha = __degrees(__atan(1/sqrt(2)))
    local beta = 45

    rotate(alpha, 1, 0, 0)
    rotate(beta, 0, 1, 0)

    if n then
        scale(n, n, n)
    end
end

function ortho3D(w, h, ratio)
    w = w or W
    h = h or H

    camera(w/2, h/2, ratio or w*0.775, w/2, h/2, 0)

    perspective()
end

function camera(eye_x, eye_y, eye_z, at_x, at_y, at_z, up_x, up_y, up_z)
    local app = app.theapp or app
    
    app.scene.camera = Camera(eye_x, eye_y, eye_z, at_x, at_y, at_z, up_x, up_y, up_z)
    app.scene.camera:setViewMatrix()

    return app.scene.camera
end
