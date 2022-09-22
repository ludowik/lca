function setup()
    scene = UIScene()
    browse('apps')
end

function autotest(dt)
    global.__autotest = true
    
    local currentApp = env
    currentApp.__autotest = false

    local ram = {
        beforeTest = format_ram()
    }

    appsList.saveCurrentIndex = appsList.saveCurrentIndex or 1
    
    Engine.draw(true)
    Engine.captureImage()
    
    local __print = _G.print
    local __log = _G.log
    _G.print = function () end
    _G.log = function () end
        
    local apps = enum('apps')
    for i = appsList.saveCurrentIndex, #apps do        
        if pumpEvent() then break end
        
        item = apps[i]
        if isApp(item) then            
            local path, name, ext = splitFilePath(item)            
            local newApp = loadApp(path, name)
            if newApp ~= currentApp then
                newApp.__autotest = true
                do
                    setActiveApp(newApp)

                    local start = time()
                    for i=1,30 do
                        Engine.update(1/60)
                        Engine.draw()
                        local current = time()
                        if current - start >= 1 then
                            break
                        end
                    end
                    
                    Engine.draw()
                    Engine.captureImage()
                end
                newApp.__autotest = false
            end
        end
        
    end
    
    ram.afterTest = format_ram()

    Engine.release()    
    ram.afterRelease = format_ram()
    
    _G.print = __print
    _G.log = __log

    print('n appps : '..#apps)
    print('before  : '..ram.beforeTest)
    print('after   : '..ram.afterTest)
    print('release : '..ram.afterRelease)

    setActiveApp(currentApp)
    
    global.__autotest = false
    
    quit()
end

function draw()
    background()
    scene:draw()
end

function touched(touch)
    if touch.state == RELEASED then
        scene:touched(touch)

    elseif touch.state == MOVING then
        scene.position.y = scene.position.y + touch.dy
    end
end

function browse(path, previousPath)
    scene:clear()
    scene.position = vec2(100, 100)

    if previousPath then
        scene:add(UI('..', function ()
                    browse(previousPath)
                end))
    end

    local list = dir(path)
    list:sort(
        function (a, b)
            if isApp(a) == isApp(b) then
                return a < b
            end
            return not isApp(a) --and isApp(b)
        end)

    for i,item in ipairs(list) do
        local path, name, ext = splitFilePath(item)
        if name ~= 'apps' then
            if isApp(item) then
                scene:add(
                    UI(name,
                        function (_)
                            loadApp(path, name)
                        end)
                    :attribs{
                        info = item}
                    :setstyles{
                        textColor = colors.green,
                        fontSize = 26})
            else
                scene:add(
                    UI(name,
                        function (_)
                            browse(item, path)
                        end)
                    :attribs{
                        info = item}
                    :setstyles{
                        textColor = colors.blue,
                        fontSize = 26})
            end
        end
    end
end

function keyboard(key)
    if key == 'a' then
        browse('apps')
    end
end
