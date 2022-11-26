function pause()
    env.scene = Scene()
end

function resume()
    setup()
end

function setup()
    supportedOrientations(LANDSCAPE_ANY)
    
    setOrigin(BOTTOM_LEFT)

    local index = 0

    local n = (debugging() and 20) or 50 -- 500

    local v = vec3()

    local w, h, d = 10, 10, 10

    local m = mesh()
    m.shader = shaders.default

    for i=0,n-1 do
        v.x = i*w

        for j=0,n-1 do
            v.z = j*w

            m.vertices[index+1] = vec3(-w/2, 0, -h/2):add(v)
            m.vertices[index+2] = vec3( w/2, 0, -h/2):add(v)
            m.vertices[index+3] = vec3( w/2, 0,  h/2):add(v)

            m.vertices[index+4] = vec3(-w/2, 0, -h/2):add(v)
            m.vertices[index+5] = vec3( w/2, 0,  h/2):add(v)
            m.vertices[index+6] = vec3(-w/2, 0,  h/2):add(v)

            index = index + 6
        end
    end

    index = 0
    for i=0,n-1 do
        x = i*w

        for j=0,n-1 do
            z = j*w

            m.vertices[index+1].y = noise(x-w/2, z-h/2) * w
            m.vertices[index+2].y = noise(x+w/2, z-h/2) * w
            m.vertices[index+3].y = noise(x+w/2, z+h/2) * w
                                                  
            m.vertices[index+4].y = noise(x-w/2, z-h/2) * w
            m.vertices[index+5].y = noise(x+w/2, z+h/2) * w
            m.vertices[index+6].y = noise(x-w/2, z+h/2) * w

            index = index + 6
        end
    end
    
    m.normals = Model.computeNormals(m.vertices)
    assert(m.normals)
    
    env.scene = Scene()
    env.scene.camera = Camera()
    
    env.scene.camera:eye(loadstring('return vec3('..(readProjectData('camera.eye') or '50, 50, 50')..')')())
    env.scene.camera:at(loadstring('return vec3('..(readProjectData('camera.at') or '0, 0, -10')..')')())
    
    env.scene:add(MeshObject(m))
end

function pause()
    saveProjectData('camera.eye', tostring(env.scene.camera:eye()))
    saveProjectData('camera.at', tostring(env.scene.camera:at()))
end

function draw3d()
    perspective()
    light(true)
    
    fill(colors.white)
    env.scene:draw()
end


