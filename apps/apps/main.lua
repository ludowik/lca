function setup()
    supportedOrientations(LANDSCAPE_ANY)

    scene = UIScene(Layout.grid, 2)
    scene:setAlignment('v-center,h-center')

    browse(APPS)

--    parameter.watch('searchTime')
--    parameter.watch('searchText')
end

function browse(path, previousPath)
    scene:clear()

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
        if name ~= APPS then
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

searchText = ''
searchTime = 0

function keyboard(key)
    if key == 'f3' then
        browse(APPS)
        return
    end

    if key == 'return' then
        local ui = scene:getFocus()
        if ui.callback then
            ui.callback(ui)
        end

    else
        if time() - searchTime > 2 then
            searchText = ''
        end

        searchTime = time()

        if key == 'backspace' then
            searchText = searchText:sub(1, searchText:len()-1)
        else
            searchText = searchText..key
        end

        local ui = scene:ui(searchText)
        if ui then
            scene:setFocus(ui)
        end
    end
end

function autotest(dt)
    global.__autotest = true

    local currentApp = env
    currentApp.__autotest = false

    local ram = {
        beforeTest = formatRAM()
    }

    appsList.saveCurrentIndex = appsList.saveCurrentIndex or 1

    Engine.draw(true)
    Engine.captureImage()

    local __print = _G.print
    local __log = _G.log
    _G.print = function () end
    _G.log = function () end

    local apps = enumFiles(APPS)
    apps:sort()

    for i = appsList.saveCurrentIndex, #apps do        
        if pumpEvent() then break end

        item = apps[i]
        if isApp(item) then            
            local path, name, ext = splitFilePath(item)            
            local newApp = loadApp(path, name)
            assert(newApp, item..','..path..','..name)
            if newApp ~= currentApp then
                newApp.__autotest = true
                do
                    setActiveApp(newApp)

                    local start = time()
                    for i=1,30 do
                        Engine.update(1/60)
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

    ram.afterTest = formatRAM()

    Engine.release()    
    ram.afterRelease = formatRAM()

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