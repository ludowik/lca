function setup()    
    model = Model.plane()
    model.shader = shaders.terrain
    uniforms = model.uniforms
    
    uniforms.pos = vec3(0, 0, 0)
    uniforms.size = vec3(10, 0, 10)

    parameter.number('uniforms.freq1', 5, 50, 10)
    parameter.number('uniforms.freq2', 1, 1000, 50)
    parameter.number('uniforms.freq3', 1, 1000, 20)

    parameter.number('uniforms.octave1', 0, 1, 1)
    parameter.number('uniforms.octave2', 0, 1, 0)
    parameter.number('uniforms.octave3', 0, 1, 0)

    camera(0, 400, -100, -100, 200, -10)
end

function draw3d()
    background(51)

    perspective()

    noLight()
    
    local camera = getCamera()
    local x, y, z = tointeger(camera.vEye.x), tointeger(camera.vEye.y), tointeger(camera.vEye.z)

    local w = 128
    
    local b = 16
    
    local n, N, dist
    for dx = -b,b do
        for dz = -b,b do            
            dist = math.sqrt(dx^2 + dz^2)
            
            n = clamp(2^floor(dist), 2, 8192)
            N = w / n
            
            model.uniforms.n = N
            
            model.uniforms.pos = vec3(dx*w + x - w/2, 0, dz*w + z - w/2)
            model.uniforms.size = vec3(n, n, n)
            
            fill(colors.white)
            
            model:draw(
                0,
                0,
                0,
                1,
                1,
                1,
                N^2)
        end
    end
end
