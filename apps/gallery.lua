function setup()
    currentIndex = 1

    apps = enumFiles(APPS)
    apps:sort()
end

function update(dt)
    currentIndex = currentIndex % #apps + 1
    fromApp(
        function ()
            Engine.update(dt)
        end)
end

function draw()
    local n = floor(sqrt(#apps)+1)
    local ratio = screenConfig.H / screenConfig.W
    local x, y, w, h
    
    w = screenConfig.W / n
    h = w * ratio
    
    x = floor(currentIndex % n) * w
    y = floor(currentIndex / n) * h
    
    fromApp(
        function ()
            Engine.draw()
            love.graphics.draw(env.canvas, x, y, 0, w/W, h/H)
        end)
end

function fromApp(f)
    local currentApp = env
    local __supportedOrientations = _G.supportedOrientations
    _G.supportedOrientations = nilf
    
    item = apps[currentIndex]
    if isApp(item) then
        local path, name, ext = splitFilePath(item)
        local newApp = loadApp(path, name)
        assert(newApp, item..','..path..','..name)

        if newApp ~= app then
            f()
        end
    end
    
    _G.supportedOrientations = __supportedOrientations
    loadApp(currentApp.appPath, currentApp.appName)
end
