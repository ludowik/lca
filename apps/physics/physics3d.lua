function setup()
    supportedOrientations(LANDSCAPE_ANY)

    physics = Physics()

    physics:setArea(-5, 0, -5, 10, 10, 10)

    function addBall()
        r = 1
        ball = Object3D('ball',
            random(-0.5, 0.5),
            4,
            0, r, r, r)
        ball.color = Color.random()
        physics:add(ball, DYNAMIC, SPHERE, r)
    end

    addBall()

    parameter.action('add ball', function () addBall() end)

    camera(0, 8, 35, 0, 0, 0)
    env.scene:add(physics)

    physics:draw()
end

function update(dt)
    env.scene:update(dt)

    local camera = getCamera()
    if camera then
        camera:rotateY(1)
    end
end

function touched(touch)
    for _,ball in ipairs(physics.bodies) do
        ball.force = vec3.random(5)
    end
end
