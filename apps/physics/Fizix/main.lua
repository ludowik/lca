function setup()
    fizix = Fizix()

    fizix.debug = true

    local ground = Rect(WIDTH/2, 0, WIDTH, 100)
    
    env.scene = Scene()
    env.scene:add(ground)

    fizix:add(ground, STATIC, RECT, ground.size.x, ground.size.y)

    for i=1,10 do
        local object = Object2D():setPosition(
            math.random(WIDTH),
            math.random(HEIGHT))

        env.scene:add(object)
        
        fizix:add(object, DYNAMIC, table.random({RECT, CIRCLE, POLYGON}))
    end

    parameter.watch("#fizix.bodies")
    parameter.watch("#fizix.contacts")

    env.scene:add(fizix)
end

function touched(touch)
    if touch.state == BEGAN then
        for i,body in ipairs(fizix.bodies) do
            if body:testPoint(touch) then
                currentObject = body
                break
            end
        end

    elseif touch.state == MOVING and currentObject then
        currentObject:touched(touch)

    else
        currentObject = nil

    end
end
