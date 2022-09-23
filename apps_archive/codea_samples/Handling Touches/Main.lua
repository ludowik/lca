-- This demo shows you how to use CurrentTouch for simple interaction
-- CurrentTouch is a global updated with a single touch position
-- Usage:
--  CurrentTouch.pos.x
--  CurrentTouch.pos.y
--  CurrentTouch.prevPos.x
--  CurrentTouch.prevPos.y
--  CurrentTouch.delta.x
--  CurrentTouch.delta.y
--  CurrentTouch.id
--  CurrentTouch.state = BEGAN | MOVING | ENDED
--  CurrentTouch.tapCount
--
-- See the Touch chapter of the documentation for more

function setup()
    -- Setting this tells the renderer to retain the previous frame when drawing
    -- you should use this if you do not call background in draw.
    -- Set it to `false` to see the difference (`false` is the default)
    viewer.retainedBacking = true

    print("Touch and drag on the screen")
end

function draw()
    noSmooth()
    
    fill(0, 0, 0, 10)
    rect(0,0,WIDTH,HEIGHT)

    noStroke()

    if CurrentTouch.state == BEGAN then
        fill(16, 178, 197, 255)
    elseif CurrentTouch.state == MOVING then
        fill(255, 0, 0, 255)
    elseif CurrentTouch.state == ENDED then
        fill(210, 218, 16, 255)
    end

    ellipse(CurrentTouch.pos.x, CurrentTouch.pos.y, 100,100)
end

