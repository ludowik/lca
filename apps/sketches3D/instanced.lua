function setup()
    m = Model.box()

    m.instancePosition = table()
    m.instanceScale = table()
    for x=-30,30 do
        for y=-30,30 do
            for z=-30,30 do
                m.instancePosition:add({x, y, z})
                m.instanceScale:add({.1,.1,.1})
            end
        end
    end

    camera(250, 250, 250)
    
    setOrigin(BOTTOM_LEFT)
end

function draw()
    background()
    perspective()
    m:drawInstanced()
end
