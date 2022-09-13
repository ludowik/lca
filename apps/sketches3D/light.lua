function setup()
    parameter.link('opengl', 'https://learnopengl.com/Lighting/Basic-Lighting')
    camera(10, 10, 10)
    setOrigin(BOTTOM_LEFT)
end

function draw3d()
    perspective()
    
    shaders.light.uniforms.iTime = elapsedTime
    
    light(true)
    box(-2, 0, 0, 1, 1,1)
    
    light(false)
    box(2, 0, 0, 1, 1,1)
end
