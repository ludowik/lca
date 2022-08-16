-- In this demo we're going to explore the new image features
--
-- Here's what we will look at
--  1. Saving an image as a sprite (into your Documents sprite pack)
--  2. Downloading an image and displaying it
--  3. Reading an image from a sprite pack
--  4. Listing the images in a sprite pack

-- Note that you can also use Dropbox to import asset.into Codea
--  To do this please set up your Dropbox account from the project
--  browser (tap the settings icon). Or you can set up Dropbox from
--  the sprite picker in this editor. Once it is setup you may save
--  and read from the "Dropbox" sprite pack. In order to sync your
--  data you must open the sprite picker and choose "Sync" from the
--  Dropbox sprite pack menu.

function setup()

    viewer.mode = OVERLAY
        ----------------------------------------------------
    -- 1. We'll call the makeCircleImage function (defined below)
    --  to create an image and save it to
    --  your Documents as "ExampleCircle"

    local img = makeCircleImage()
    saveImage(tostring(asset.documents) .. "ExampleCircle",img)

    -- Once you've run this code come back here and tap
    --  the blue highlight above to verify the image is in
    --  your Documents
    ---------------------------------------------------

    ---------------------------------------------------
    -- 2. Now we'll download our logo into an image
    logo = nil -- it's empty for now

    -- Start the request, didGetLogo is our callback function
--    http.request( "http://twolivesleft.com/logo.png", didGetLogo )
    ---------------------------------------------------

    ---------------------------------------------------
    -- 3. Now we'll read the image we saved above back out
    --  Note: you can read images from any sprite pack,
    --   including the built in ones
    --  Note: we use the bracket syntax here because the file
    --   does not yet exist and Codea will complain if
    --   we statically refer to asset.not on disk
    circleImage = readImage(asset.documents["ExampleCircle.png"])
    ---------------------------------------------------

    ---------------------------------------------------
    -- 4. Now let's list the asset.in Documents
    print("Assets contained in 'Documents'")
    for _,k in pairs(asset.documents.all) do
        print(k.name)
    end
    print("")
    ---------------------------------------------------
end

function makeCircleImage()
    -- This function makes a red circle
    -- Renders it into an image, and returns the image
    local size = math.min(400, WIDTH - 180)
    local img = image(size, size)
    ------------------------------------
    -- Use the image as a render target
    setContext(img)
    background(0,0,0,0) -- transparent background
    fill(255, 131, 0, 255)
    ellipse(size/2,size/2,size/2)
    -- Set render target back to screen
    setContext()
    ------------------------------------
    return img
end

function didGetLogo( theLogo, status, headers )
    print( "Response Status: " .. status )

    -- Store logo in our global variable
    logo = theLogo

    -- Check if the status is OK (200)
    if status == 200 then
        print( "Downloaded logo OK" )
        print( " Image dimensions: " ..
                    logo.width .. "x" .. logo.height )
    else
        print( "Error downloading logo" )
    end
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color
    background(40, 40, 50)

    -- Draw the logo we downloaded (when it's ready!)
    if logo ~= nil then
        sprite( logo, WIDTH/2, HEIGHT/2, WIDTH )
    end

    -- Draw the circle image we saved and read from the sprite pack
    sprite( circleImage, WIDTH/2, 110 )
end
