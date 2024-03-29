function setup()
    scene = UIScene(Layout.grid, 2)
    scene:setAlignment('v-center,h-center')

    browse(APPS)
end

function browse(path, previousPath)
    scene:clear()

    local fontSize = floor(min(W, H) / 20)

    if previousPath then
        scene:add(UI('..', function ()
                    browse(previousPath)
                end))
        scene:add(UISpace())
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
                    UI(name:replace('_', ' '),
                        function (_)
                            loadApp(path, name)
                        end)
                    :attribs{
                        info = item}
                    :setstyles{
                        textColor = colors.green,
                        fontSize = fontSize})
            else
                scene:add(
                    UI(name:replace('_', ' '),
                        function (_)
                            browse(item, path)
                        end)
                    :attribs{
                        info = item}
                    :setstyles{
                        textColor = colors.blue,
                        fontSize = fontSize})
            end
        end
    end
end

function resize()
    browse(APPS)
end

function draw()
    background()

--    if getOrientation() == PORTRAIT then
--        scene.layoutParam = 1
--    else
--        scene.layoutParam = 2
--    end

    scene:draw()
end

function touched(touch)
    if touch.state == RELEASED then
        scene:touched(touch)

    elseif touch.state == MOVING then
        scene.position.y = scene.position.y + touch.dy
    end
end

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
    end
end

function autotest(dt)
    global.__autotest = true

    local currentApp = env
    currentApp.__autotest = false

    local __print = _G.print
    local __log = _G.log
    _G.print = function () end
    _G.log = function () end

    appsList.saveCurrentIndex = appsList.saveCurrentIndex or 1

    Engine.draw(true)
    Engine.captureImage()

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
                    local start = time()
                    for i=1,30 do
                        Engine.update(1/60)
                        local current = time()
                        if current - start >= 1 then
                            break
                        end
                    end

                    Engine.draw(true)
                    Engine.captureImage()
                end
                newApp.__autotest = false
            end
        end

    end

    Engine.release()    

    _G.print = __print
    _G.log = __log

    print('n appps : '..#apps)

    loadApp(currentApp.appPath, currentApp.appName)

    global.__autotest = false
end
