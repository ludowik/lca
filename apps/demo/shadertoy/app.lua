function setup()
    setOrigin(BOTTOM_LEFT)

    shadertoys = table()

    local wmin = ws(1, 6)
    local wmax = ws(8, 8)

    minSize = vec2(wmin, wmin*9/16):round()
    maxSize = vec2(wmax, wmax*9/16):round()

    mesh = Model.rect()    
    mesh.uniforms = {
        iResolution = vec3(),

        iTime = 0,
        iTimeDelta = 0,

        iFrame = 0,
        iFrameRate = 60,

        iMouse = vec4()
    }

    shadersPath = appPath..'/'..appName..'/shaders'

    env.thread = coroutine.create(
        function (dt)
            loadShaders(true)
        end)
end

function suspend()
    for i,shader in ipairs(shadertoys) do
        shader:release()
    end
end

function initUI(zoom)
    local ui = UI()

    if zoom then
        ui.size = maxSize
    else
        ui.size = minSize
    end

    ui.canvas = Image(ui.size.x, ui.size.y)

    ui.position = vec2()
    ui.absolutePosition = ui.position

    return ui
end

function loadShaders(all)
    local directoryItems = dir(shadersPath)

    for i,shaderFileName in ipairs(directoryItems) do
        local _path,_name,extension = splitFilePath(shaderFileName)
        if extension ~= 'vertex' then
            local shader = ShaderToy(_name, _path)
            if shader and shader.error == nil then
                initShader(shader, #shadertoys == 1)
                shadertoys:add(shader)
            end

            if env.thread then
                if all then
                    coroutine.yield()
                else
                    loadNext = false
                    while loadNext == false do
                        coroutine.yield()
                    end
                end
            elseif not all then
                break
            end
        end
    end
end

function initShader(shader, active)
    shader.active = active

    shader.ui = initUI(false)
    shader.zoom = initUI(true)

    drawShader(shader, shader.ui)
    drawShader(shader, shader.zoom)
end

function drawShader(shader, ui)
    setContext(ui.canvas)
    do
        depthMode(false)

        mesh.shader = shader

        mesh.uniforms.iResolution = vec3(
            ui.size.x,
            ui.size.y,
            1)

        mesh.uniforms.iTime = mesh.uniforms.iTime + deltaTime
        mesh.uniforms.iTimeDelta = deltaTime

        mesh.uniforms.iFrame = mesh.uniforms.iFrame + 1
        mesh.uniforms.iFrameRate = 60

        local touch = mouse
        if Rect.contains(ui, touch) then
            stroke(colors.red)
            strokeSize(10)
            rect(0, 0, ui.size.x, ui.size.y)
            
            local x, y = touch.x, touch.y

            x = x - ui.absolutePosition.x
            y = y - ui.absolutePosition.y

            mesh.uniforms.iMouse.x, mesh.uniforms.iMouse.y = x, y

            if isButtonDown(BUTTON_LEFT) then
                mesh.uniforms.iMouse.z, mesh.uniforms.iMouse.w = x, y
            else
                mesh.uniforms.iMouse.z, mesh.uniforms.iMouse.w = -1, -1
            end
            
        else            
            mesh.uniforms.iMouse = vec4()
        end

        for k,v in pairs(shaderChannel) do
            shader.texture = shaderChannel[0]
            mesh.uniforms.iChannel0 = shader.texture
        end

        mesh:draw(0, 0, 0, ui.size.x, ui.size.y, 1)
    end
    setContext()
end

function update(dt)
end

function draw()
    background(51)

    for i,shader in ipairs(shadertoys) do
        if shader.active then
            drawShader(shader, shader.ui)
            drawShader(shader, shader.zoom)
        end
    end

    local currentActiveShader, nextActiveShader

    local x, y = 0, HEIGHT
    local w, h = textSize('A')

    for i,shader in ipairs(shadertoys) do
        if shader.active then
            currentActiveShader = shader
        end

        local size = shader.ui.size

        shader.ui.canvas:draw(x, y - size.y)

        if shader.active then
            stroke(colors.red)
        else
            stroke(colors.white)
        end
        noFill()

        rectMode(CORNER)
        rect(x, y - size.y, size.x, size.y)

        fill(colors.white)

        fontSize(8)

        local path, name, ext = splitFilePath(shader.name)
        textMode(CENTER)
        text(name, x+size.x/2, y-size.y-h/2)

        shader.ui.position = vec2(x, y - size.y)
        shader.ui.absolutePosition = shader.ui.position

        x = x + size.x
        if x + size.x > WIDTH  then
            x = 0
            y = y - size.y - h
        end
    end

    x = 0
    y = y - minSize.y - h

    if currentActiveShader then
        local size = currentActiveShader.zoom.size
        
        currentActiveShader.zoom.position = vec2(0, y-y/2)
        currentActiveShader.zoom.absolutePosition = currentActiveShader.zoom.position

        spriteMode(CENTER)
        sprite(currentActiveShader.zoom.canvas, W/2, y-y/2)
    end
end

function touched(touch)
    if touch.state == BEGAN then
        loadNext = true

        local currentActiveShader, nextActiveShader
        for i,shader in ipairs(shadertoys) do
            if shader.active then
                currentActiveShader = shader
            end
            if Rect.contains(shader.ui, touch) then
                loadNext = false
                nextActiveShader = shader
            end
        end

        if nextActiveShader then
            if currentActiveShader then
                initShader(currentActiveShader, false)
            end

            initShader(nextActiveShader, true)
        end
    end
end
