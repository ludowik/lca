-- Use this function to perform your initial setup
viewer.mode = STANDARD

function setup()
    parameter.number("Freq",0,5,2)
    parameter.integer("Texture",1,5,1)

    allTextures = {
                    CAMERA,
                    asset.builtin.Cargo_Bot.Codea_Icon,
                    asset.builtin.Small_World.Store_Extra_Large,
                    asset.builtin.Small_World.Windmill,
                    asset.builtin.Tyrian_Remastered.Boss_D,
                  }

    cameraSource(CAMERA_FRONT)

    m = mesh()
    m.texture = allTextures[Texture]
    m.shader = shader(asset.builtin.Effects.Ripple)

    rIdx = m:addRect(0, 0, 0, 0)
    --m:setRectColor(i, 255,0,0)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Here we set up the rect texture and size
    m.texture = allTextures[Texture]
    local cw,ch = spriteSize(allTextures[Texture])
    m:setRect(rIdx, WIDTH/2, HEIGHT/2, cw, ch)

    -- Configure out custom uniforms for the ripple shader
    m.shader.time = elapsedTime
    m.shader.freq = Freq

    -- Draw the mesh
    m:draw()
end
