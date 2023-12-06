function setup()
    parameter.link('opengl', 'https://learnopengl.com/lighting/basic-lighting')

    local function addParameters(name, v)
        parameter.watch('#'..name)

        for i,v in pairs(v) do
            for k,v in pairs(v) do
                if type(v) == 'number' then
                    parameter.number('lights[1].'..k, 0, 1)

                elseif classnameof(v) == 'Color' then
                    parameter.color('lights[1].'..k)

                end
            end
        end
    end
    
    addParameters('lights', lights)

    camera(10, 10, 10)
    setOrigin(BOTTOM_LEFT)
end

function draw3d()
    perspective()

    shaders.default.uniforms.iTime = elapsedTime

    light(true)
    material(Material())
    box(-2, 0, 0, 1, 1,1)

    noLight()
    noMaterial()
    box(2, 0, 0, 1, 1,1)
end
