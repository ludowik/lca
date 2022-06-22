class 'Engine'

function Engine.load()
    Engine.graphics = config.renderer == 'core' and GraphicsCore() or GraphicsLove()

    deltaTime = 0
    elapsedTime = 0

    classes.setup()

    setupWindow()

    resetMatrix(true)
    resetStyle()

    disableGlobal()

    addApps()

    if config.appName then
        loadApp(config.appPath, config.appName)
    else
        loadApp('app', 'info')
    end
end

function Engine.unload()
    saveConfig()
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

function Engine.update(dt)
    if Engine.test then

        Engine.test.delay = Engine.test.delay - dt
        if Engine.test.delay <=0 then

            if Engine.test.index == 1 then
                Engine.test.ram = format_ram()
                
            elseif Engine.test.index > getnApps() then
                print('début du test')
                print(Engine.test.ram)
                
                print('fin du test')
                print(format_ram())

                gc()
                print(format_ram())

                resetApps()
                
                GraphicsBase.release()
                Image.release()
                
                gc()
                print(format_ram())

                exit()
            end

            setApp(Engine.test.index, false)

            Engine.test.delay = 0.05
            Engine.test.index = Engine.test.index + 1

        end
    end

    deltaTime = dt
    elapsedTime = elapsedTime + dt

    _G.env.tweensManager:update(dt)

    callApp('update', dt)
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

function Engine.beginDraw()
    if not _G.env.canvas then
        _G.env.canvas = love.graphics.newCanvas(W, H)
        --        _G.env.depthBuffer = love.graphics.newCanvas(W, H, {format="depth24", readable=true})

        love.graphics.setCanvas({
                _G.env.canvas,
                depth = true,
            })

        love.graphics.clear(0, 0, 0, 1, true, true)
    end

    love.graphics.setCanvas({
            _G.env.canvas,
            depth = true,
        })

    love.graphics.setWireframe(config.wireFrame and true or false)
end

function Engine.endDraw(reverseY)
    love.graphics.setCanvas()
    love.graphics.origin()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setScissor()
    love.graphics.setBlendMode('replace')
    love.graphics.setWireframe(false)
    love.graphics.clear(.5, .5, .5, 1)

    local source
    if _G.env.imageData then
        _G.env.imageData:update()
        source = _G.env.imageData.data
    else
        source = _G.env.canvas
    end

    if reverseY then
        love.graphics.draw(source, X, H+Y, 0, 1, -1)
    else
        love.graphics.draw(source, X, Y)
    end
end

function Engine.draw()
    if _G.env.draw then
        Engine.beginDraw()
        if Engine.needDraw() then
            Engine.render(function ()
                    depthMode(false)
                    cullingMode(false)
                    if getCamera() then getCamera():lookAt() end
                    _G.env.draw()
                end)
        end
        Engine.endDraw()
    end

    if _G.env.draw3d then
        Engine.beginDraw()
        do
            Engine.render(function ()
                    depthMode(true)
                    cullingMode(true)
                    love.graphics.clear()
                    if getCamera() then getCamera():lookAt() end
                    _G.env.draw3d()
                end
            )
        end
        Engine.endDraw(true)
    end

    love.graphics.setDepthMode('always', true)

    Engine.render(function()
            text(getFPS())
            text(os.name)
            text(env.appName)
            text(W..'x'..H)

            text(string.format('%d,%d,%d,%d', love.window.getSafeArea()))
            text(string.format('%d,%d', mouse.x, mouse.y))
            
            text(config.renderer)

            callApp('drawInfo')
        end, 10, Y)

    Engine.render(function()
            env.parameter.scene.position:set(W, 0)
            env.parameter:draw()
        end, X, Y)
end

TOP_LEFT = 'top_left'
BOTTOM_LEFT = 'bottom_left'

function setOrigin(origin)
    if _G.env then
        _G.env.origin = origin
    end
end

function getOrigin()
    if _G.env and _G.env.origin then
        return _G.env.origin
    end
    return TOP_LEFT
end

LANDSCAPE_ANY = 'LANDSCAPE_ANY'
function supportedOrientations()
    -- TODO
end

function displayMode()
    -- TODO
end
