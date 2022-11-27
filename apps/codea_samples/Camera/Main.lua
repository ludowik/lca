-- Camera

-- Use this function to perform your initial setup
function setup()
    print("This example shows you how to use camera input")
    
    -- Create a couple buttons for our camera source
    parameter.action("Front Camera", function()
                                        cameraSource(CAMERA_FRONT)
                                     end)

    parameter.action("Back Camera",  function()
                                        cameraSource(CAMERA_BACK)
                                     end)

    parameter.action("Take Photo", takePhoto)
    
    parameter.boolean("Depth", false, function()
        if Depth then
            print("This feature requires depth sensing hardware on the specified camera source")
        end
    end)

    -- Start using the front camera
    cameraSource(CAMERA_FRONT)
    
    -- A variable to hold our captured photo
    capturedImage = nil
end

function takePhoto()
    capturedImage = image(CAMERA)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Get the size of the current camera texture
    local camWidth, camHeight = spriteSize( CAMERA )

    -- Draw the special CAMERA sprite
    if Depth then 
        sprite( CAMERA_DEPTH, WIDTH/2, HEIGHT/2, math.min( camWidth, WIDTH ) )
    else 
        sprite( CAMERA, WIDTH/2, HEIGHT/2, math.min( camWidth, WIDTH ) )
    end

    -- Draw our captured image if available
    if capturedImage ~= nil then
        pushStyle()
        spriteMode(CORNER)
        sprite(capturedImage, WIDTH/2 - 100, 0, 200)
        popStyle()
    end
end