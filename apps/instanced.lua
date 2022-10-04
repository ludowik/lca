function setup()
    m = Model.box()

    m.instancePosition = table()
    m.instanceScale = table()
    for x=-50,50 do
        for y=-50,50 do
            for z=-50,50 do
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
    m:drawInstanced(1)
end
