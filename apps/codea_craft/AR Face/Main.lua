-- AR Face Tracking
-- Please note that only devices with a TrueDepth camera will support this project

function setup()
    viewer.mode = OVERLAY

    -- FaceScene contains all the logic for handling the tracking and rendering
    scene = FaceScene()
end

-- Called automatically by codea
function draw()
    -- Update the scene to keep everything up to date
    scene:update(DeltaTime)

    -- Draw the scene
    scene:draw(WIDTH, HEIGHT, 1)
end
