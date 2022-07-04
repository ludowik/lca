require 'engine.core'
require 'engine'

if loadLibc then
    require 'libc.library'
    require 'libc.sdl.sdl'
    require 'libc.opengl.opengl'
    require 'libc.openal.openal'
    require 'libc.freetype.freetype'

    renderer = OpenGL()

    sdl = Sdl()
    sdl:initialize()
-- renderer:initialize()

    al = OpenAL()
    al:initialize()


    FreeType.setup()

    ft = FreeType()
    ft:initialize()
end

if true then
    love.run = function () end
    love.setup = function () end
    
    love.graphics = {
        replaceTransform = love.graphics.replaceTransform,
        
        setDepthMode = love.graphics.setDepthMode,
        setMeshCullMode = love.graphics.setMeshCullMode,
        setFrontFaceWinding = love.graphics.setFrontFaceWinding,
        setBlendMode = love.graphics.setBlendMode,
        setColor = love.graphics.setColor,
        setWireframe = love.graphics.setWireframe,
        
        newFont = love.graphics.newFont,
        setFont = love.graphics.setFont,
        getFont = love.graphics.getFont,
        newText = love.graphics.newText,
        
        newCanvas = love.graphics.newCanvas,
        setCanvas = love.graphics.setCanvas,
        getCanvas = love.graphics.getCanvas,
        
        newMesh = love.graphics.newMesh,
        newImage = love.graphics.newImage,
        
        newShader = love.graphics.newShader,
        setShader = love.graphics.setShader,
        getShader = love.graphics.getShader,
        _shaderCodeToGLSL = love.graphics._shaderCodeToGLSL,
        getSupported = love.graphics.getSupported,
        isGammaCorrect = love.graphics.isGammaCorrect,
        
        getBackgroundColor = love.graphics.getBackgroundColor,
        clear = love.graphics.clear,
        origin = love.graphics.origin,
        draw = love.graphics.draw,
        present = love.graphics.present,
        
        setScissor = love.graphics.setScissor,
    }

    config.renderer = 'core'
    Engine.load()

    while true do
        -- Process events.
        if love.event then
            love.event.pump()
            for name, a,b,c,d,e,f in love.event.poll() do
                if name == "quit" then
                    if not love.quit or not love.quit() then
                        return a or 0
                    end
                end
                love.handlers[name](a,b,c,d,e,f)
            end
        end

        -- Update dt, as we'll be passing it to update
        local dt
        if love.timer then
            love.timer.step()
            dt = love.timer.getDelta()
        end

        -- Call update and draw
        Engine.update(dt)
--        if love.update then
--            love.update(dt)
--        end -- will pass 0 if love.timer is disabled

        if love.graphics then -- and love.graphics.isActive() then
            love.graphics.clear(love.graphics.getBackgroundColor())
            love.graphics.origin()

            Engine.draw()
--            if love.draw then
--                love.draw()
--            end

            love.graphics.present()
        end

--        if love.timer then love.timer.sleep(0.001) end
    end
end
