function setup()
    scene:add(pyramid('Khéops', 0, 0, 0, 230.902, 144.93, 201, floor(144.93/0.69)))
    scene:add(pyramid('Khéphren', -340, 0, -370, 215.16, 143.87, 201, floor(144.93/0.69)))
    
    camera(1000, 1.8, 1000, 0, 1.8, 0)

    setOrigin(BOTTOM_LEFT)

    parameter.boolean('lightMode', true)
    parameter.number('param1', 0, 1000, 65)
end

function pyramid(name, x, y, z, W, H, nw, nh)
    local model = Model.box()
    local object = MeshObject(model)
    
    object.position = vec3(x, y, z)

    model.instancePosition = table()
    model.instanceScale = table()
    model.instanceColor = table()

    local w = W/nw
    local h = H/nh
    
    local maxy = nw-10
    
    for y=1,maxy do
        for x=1,(nw+1-y) do
            for z=1,(nw+1-y) do
                if x == 1 or x == (nw+1-y) or z == 1 or z == (nw+1-y) or y == maxy then
                    model.instancePosition:add({
                            (x-(nw+1-y)/2)*w,
                            y*h,
                            (z-(nw+1-y)/2)*w})
                    model.instanceScale:add({w*.95, h*.95, w*.95})
                    model.instanceColor:add({Color(229, 181, 114):unpack()})
                end
            end
        end
    end
    
    return object
end

function draw()
    background(colors.blue)
    perspective()
    
    light(lightMode)
        
    stroke(colors.red)
    plane(0, 0, 0, 2000, 1, 2000)
    
    scene:draw()
end
