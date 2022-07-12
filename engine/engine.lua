class 'Engine'

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

function Engine.load()
    Engine.setGraphicsLibrary()

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
        loadApp('apps', 'info')
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
        if Engine.test.delay <= 0 then

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

    if _G.env.__autotest then
        callApp('autotest', dt)
    end    

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

function Engine.beginDraw(origin)
    Engine.origin = origin
    if not _G.env.canvas then
        _G.env.canvas = love.graphics.newCanvas(W, H)

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

function Engine.endDraw()
    love.graphics.setCanvas()
    love.graphics.setShader()
    love.graphics.origin()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setScissor()
    love.graphics.setBlendMode('replace')
    love.graphics.setWireframe(false)

    local source
    if _G.env.imageData then
        _G.env.imageData:update()
        source = _G.env.imageData.data
    else
        source = _G.env.canvas
    end

    local reverseY = Engine.origin == BOTTOM_LEFT

    if reverseY then
        love.graphics.draw(source, X, H+Y, 0, 1, -1)
    else
        love.graphics.draw(source, X, Y)
    end
end

function Engine.draw()
    love.graphics.clear(.5, .5, .5, 1)

    local x, y = love.mouse.getPosition()
    if x < X then
        Engine.draw2d()
        Engine.draw3d()    
        Engine.drawInfo()
    else
        Engine.drawInfo()
        Engine.draw2d()
        Engine.draw3d()
    end

end

function Engine.draw2d()
    if _G.env.draw or _G.env.draw2d then
        Engine.beginDraw(getOrigin())
        if Engine.needDraw() then
            Engine.render(function ()
                    depthMode(false)
                    cullingMode(false)
                    if getCamera() then getCamera():lookAt() end
                    (_G.env.draw or _G.env.draw2d)()
                end)
        end
        Engine.endDraw()
    end
end

function Engine.draw3d()
    if _G.env.draw3d then
        Engine.beginDraw(BOTTOM_LEFT)
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
end

function Engine.drawInfo()
    love.graphics.setDepthMode('always', true)

    Engine.origin = TOP_LEFT

    Engine.render(function()
            text(getFPS())
            text(os.name)
            text(env.appName)
            text(W..'x'..H)

            text(string.format('%d,%d,%d,%d', love.window.getSafeArea()))
            text(string.format('%d,%d', mouse.x, mouse.y))

            text(config.framework)
            text(config.renderer)

            callApp('drawInfo')

            Log.draw(0, 20)
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
