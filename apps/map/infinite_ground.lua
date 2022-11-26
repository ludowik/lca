function setup()
    setOrigin(BOTTOM_LEFT)

    initMesh()
end

function initMesh()
    local size = 50
    local n = 10

    env.ground = Model.ground(size) -- plane(10, 0, 10)
    env.ground.uniforms.computeHeight = true

    for x=-n,n do
        for z=-n,n do
            env.ground.instancePosition:add{x*size, 0, z*size}
            
            local clr = colors.green
            env.ground.instanceColor:add{clr:unpack()}
        end
    end
    
    position = vec3(0, size, -n*size)
    
    direction = vec3(0, -10, size)
    
    at = position + direction
    
    camera(
        position.x, position.y, position.z,
        at.x, at.y, at.z)
end

function update(dt)
    position:add(vec3(direction.x, 0, direction.z) * dt)
        
    at = position + direction
    
    camera(
        position.x, position.y, position.z,
        at.x, at.y, at.z)
end

function draw()
    background(51)

    perspective()
    
    light(true)

    fill(colors.white)
    
    translate(position.x, 0, position.z)
    
    env.ground.uniforms.translation = position /2
    env.ground.uniforms.lightModeExtra = 2
    env.ground:draw(0, 0, 0)
end
