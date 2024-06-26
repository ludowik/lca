class 'Engine'

function Engine.load()
    --override()

    Engine.setGraphicsLibrary()

    Engine.frameTarget = 60

    deltaTime = 0
    elapsedTime = 0

    classes.setup()

    setupWindow()

    resetMatrix(true)
    resetStyle()

    disableGlobal()

    addApps()

    loadApp(config.appPath, config.appName)
end

function Engine.setGraphicsLibrary()
    if config.renderer == 'love2d' then
        Engine.graphics = GraphicsLove()

    elseif config.renderer == 'core' then
        Engine.graphics = GraphicsCore()
        GraphicsCore.drawMesh = GraphicsCore._drawMeshCore

    else
        Engine.graphics = GraphicsCore()
        GraphicsCore.drawMesh = GraphicsCore._drawMeshSoft
    end
end

function Engine.unload()
    local _, _, flags = love.window.getMode()    
    config.flags = flags

    local orientation = getOrientation()
    config[orientation] = config[orientation] or {}
    config[orientation].x = flags.x
    config[orientation].y = flags.y

    config.WMAX = env.parameter.instance.scene.WMAX or 0

    Engine.pause()

    saveConfig()

    --unoverride()
end

function Engine.pause()
    callApp('pause')

    local camera = getCamera()
    if camera then
        saveProjectData('camera.eye', tostring(camera:eye()))
        saveProjectData('camera.at', tostring(camera:at()))
    end
end

function Engine.resume()
    callApp('resume')
end

function Engine.release() -- free max of memory
    -- TOFIX
--    resetApps()

    output.clear()
    Image.release()
    GraphicsBase.release()

    gc()
end

function Engine.autotest()
    env.parameter.random()
end

function Engine.update(dt)
    deltaTime = dt
    elapsedTime = elapsedTime + dt

    env.tweensManager:update(dt)

    env.parameter.interface.update(dt)
    env.physics.interface.update(dt)

    Application.updateCoroutine(env, dt)

    if env.__autotest then
        if canCallApp('autotest') then
            callApp('autotest', dt)
        else
            Engine.autotest()
        end
    end

    callApp('update', dt)

    local camera = getCamera()
    if camera then -- and camera.lookAt then -- TODEL
        camera:update(dt)
    end
end

function Engine.draw(present)
    local previousCanvas = love.graphics.getCanvas()
    pushMatrix()

    if present then
        local clr = Color(51)
        love.graphics.clear(clr.r, clr.g, clr.b, 1, true, true)
    end
    
    Engine.draw2d()
    Engine.draw3d()

    Engine.drawInfo()

    if present then
        love.graphics.present()
    end

    popMatrix()
    love.graphics.setCanvas(previousCanvas)
end

function Engine.draw2d()
    local draw = env.draw or env.draw2d
    if draw then
        Engine.beginDraw(getOrigin())
        if Engine.needDraw() then
            Engine.render(function ()
                    depthMode(true)
                    cullingMode(false)
                    if getCamera() and getCamera().lookAt then getCamera():lookAt() end
                    draw()
                end)
        end
        Engine.endDraw()
    end
end

function Engine.draw3d()
    local draw = env.draw3d
    if draw then
        Engine.beginDraw(BOTTOM_LEFT)
        do
            Engine.render(function ()
                    depthMode(true)
                    cullingMode(true)
                    love.graphics.clear()
                    if getCamera() and getCamera().lookAt then getCamera():lookAt() end
                    draw()
                end
            )
        end
        Engine.endDraw(true)
    end
end

function Engine.needDraw()
    if env.__loop > 0 then
        return true
    end
    if env.__loop == 0 then
        return false
    end    
    if env.__loop < 0 then
        env.__loop = env.__loop + 1
        return true
    end
    return false
end

function Engine.render(f, x, y)
    if not f then return end

    resetMatrix(true)
    resetStyle()

    if x then
        translate(x, y)
    end

    clip()

    f()
end

function Engine.beginDraw(origin)
    Engine.origin = origin

    if not env.canvas or env.canvas:getWidth() ~= W then
        env.canvas = love.graphics.newCanvas(W, H)

        love.graphics.setCanvas({
                env.canvas,
                depth = true,
            })

        love.graphics.clear(0, 0, 0, 1, true, true)
    end

    love.graphics.setCanvas({
            env.canvas,
            depth = true,
        })

    love.graphics.setWireframe(config.wireFrame and true or false)
end

function Engine.endDraw()
    love.graphics.setCanvas()
    love.graphics.setShader()
    love.graphics.origin()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setScissor()
    love.graphics.setBlendMode('replace')
    love.graphics.setWireframe(false)

    local source
    if env.imageData then
        env.imageData:update()
        source = env.imageData.data
    else
        source = env.canvas
    end

    local reverseY = Engine.origin == BOTTOM_LEFT

    if reverseY then
        love.graphics.draw(source, X, H/SCALE_APP + Y, 0, 1/SCALE_APP, -1/SCALE_APP)
    else
        love.graphics.draw(source, X, Y, 0, 1/SCALE_APP, 1/SCALE_APP)
    end
end

function Engine.collide(...)
    callApp('collide', ...)
end

function Engine.drawInfo()
    Engine.origin = TOP_LEFT

    resetMatrix(true)
    ortho()

    Engine.render(
        function()
            fontSize(12)            
            translate(0, -fontSize())
            
            -- TODEL
--            local r = fontSize()
--            local pct = min(getFPS(), 60)/60
--            noStroke()            
--            fill(colors.green)
--            rectMode(CORNER)
--            rect(-r, 0, r, r)
--            fill(colors.red)
--            rect(-r, 0, r, r*(1-pct))

            -- TODEL
--            if debugging() then
--                fontName('Foundation-Icons')
--                textMode(CENTER)
--                text(utf8.char(iconsFont.camera), -r/2, 2.5*r)
--                fontName('Arial')
--            end

            textMode(CORNER)

            textPosition(0)

            local x, y = 0, 0
            local function text(info)
                x = x + GraphicsBase.text(info, x, y) + fontSize()
            end

            text(os.name)
            text(debugging() and 'debug mode' or 'release mode')

            if env.__autotest then
                text('autotest')
            end

            callApp('drawInfo')

            if config.show.showLogs then
                Log.draw(0, 0)
            end
        end, X, Y-10)

    Engine.render(
        function()
            env.parameter.interface.draw()
        end, X, Y)
end

TOP_LEFT = 'top_left'
BOTTOM_LEFT = 'bottom_left'

function setOrigin(origin)
    if env then
        env.origin = origin
    end
end

function getOrigin()
    if env and env.origin then
        return env.origin
    end
    return TOP_LEFT
end
