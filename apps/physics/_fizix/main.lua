function setup()
    physics = Physics()

    physics.debug = true

    local ground = Rect(WIDTH/2, 0, WIDTH, 100)
    
    env.scene:add(ground)

    physics:add(ground, STATIC, RECT, ground.size.x, ground.size.y)

    for i=1,10 do
        local object = Object2D():setPosition(
            math.random(WIDTH),
            math.random(HEIGHT))

        env.scene:add(object)
        
        physics:add(object, DYNAMIC, table.random({RECT, CIRCLE, POLYGON}))
    end

    parameter.watch("#physics.bodies")
    parameter.watch("#physics.contacts")

    env.scene:add(physics)
end

function touched(touch)
    if touch.state == BEGAN then
        for i,body in ipairs(physics.bodies) do
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
