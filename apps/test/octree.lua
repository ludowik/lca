function setup()
    parameter.number('AREA_SIZE', 100, 20000, H)
    parameter.number('BOX_SIZE', 1, 1000, 100)
    
    camera(vec3(W/2, W/2, -W))
    
    autotest()
end

function autotest()
    array = table()
    for i=1,100 do
        array:add(Box.random(W, W, W, 50))
    end
end

function draw3d()
    background(colors.black)

    perspective()
    light(true)
    
    box(0,0,0,1,1,1)
    
    translate(-W/2, -W/2, -W/2)

    q = Octree(AREA_SIZE, BOX_SIZE)

    for i=1,#array do
        q:add(array[i])
    end

    q:draw()
end
