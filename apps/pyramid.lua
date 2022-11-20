function setup()
    m = Model.box()
    m.instancePosition = table()
    m.instanceColor = table()

    for y=0,30 do
        for x=-30+y,30-y do
            for z=-30+y,30-y do
                m.instancePosition:add({x, y, z})
                m.instanceColor:add({Color.random():unpack()})
            end
        end
    end

    camera(25, 15, 15)

    setOrigin(BOTTOM_LEFT)
    
    parameter.boolean('lightMode', true)
    parameter.number('param1', 0, 1000, 65)
end

function draw()
    background()
    perspective()
    light(lightMode)
    
--    m.uniforms = m.uniforms or {}
--    m.uniforms.param1 = param1
    m:drawInstanced()
end
