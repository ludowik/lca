

-- Use this function to perform your initial setup
function setup()
    print("TAP to JUMP")
    print("Tilt your device to land on the clouds!")
    print("Press RESET to restart the level")

    clouds = CloudLevels()

    girl = Girl()
    girl.position = vec2(0, 0)
end

-- This function gets called once every frame
function draw()
    background(47, 145, 216, 255)

    -- Center the camera on the girl character
    camPos = vec2(WIDTH/2,
                  math.min(HEIGHT/2 - girl.position.y, 140))
    translate(camPos.x,camPos.y)

    -- Draw ground
    for i = 1,12 do
        sprite(asset.builtin.Planet_Cute.Grass_Block, -WIDTH/2 -70 + 101*i, -60)
    end

    clouds:update(camPos)

    clouds:draw()
    girl:draw()

    if clouds:isColliding(girl.position) and
       girl:isFalling() then
        girl:jump(math.random(30,60))
    end
end

function touched(touch)
    if touch.tapCount == 1 and
       girl.position.y == 0 then
        girl:jump(40)
    end
end
