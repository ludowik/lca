function setup()
    scene = UIScene()
    browse('apps')
end

function autotest(dt)
    local currentApp = env
    currentApp.__autotest = false

    local ram = {
        before = format_ram()
    }

    appsList.saveCurrentIndex = appsList.saveCurrentIndex or 1
        
    local apps = enum('apps')
    for i=appsList.saveCurrentIndex,#apps do
        if pumpEvent() then break end
        
        item = apps[i]
        if isApp(item) then        
            local path, name, ext = splitFilePath(item )
            local newApp = loadApp(path, name)
            if newApp ~= currentApp then
                newApp.__autotest = true
                do
                    setActiveApp(newApp)

                    local start = time()
                    for i=1,60*10 do                        
                        Engine.update(1/60)
                        local current = time()
                        if current - start > 1 then
                            break
                        end
                    end

                    Engine.draw(true)
                end
                newApp.__autotest = false
            end
        end
    end

    ram.after = format_ram()

    gc()
--    resetApps()
    GraphicsBase.release()
    Image.release()
    gc()

    ram.afterRelease = format_ram()

    output.clear()

    print('avant : '..ram.before)
    print('après : '..ram.after)
    print('release & gc : '..ram.afterRelease)

    setActiveApp(currentApp)
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
