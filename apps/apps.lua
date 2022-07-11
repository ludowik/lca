function setup()
    scene = UIScene()
    browse('apps')
end

function autotest(dt)
    local currentApp = env
    currentApp.__autotest = false

    local apps = enum('apps')    
    for i,path in ipairs(apps) do
        if isApp(path) then
            print(path)
        
            local newApp = loadApp(path)
            if newApp ~= currentApp then
                newApp.__autotest = true
                setActiveApp(newApp)

                local start = time()
                for i=1,60 do
                    love.update(1/60)
                    love.draw()
                    local current = time()
                    if current - start > 1 then
                        break
                    end
                end

                love.graphics.present()
            end
        end
    end

    setActiveApp(currentApp)
end

function draw()
    background(gray)

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
                scene:add(UI(name,
                        function (_)
                            loadApp(path, name)
                        end):attribs{
                        info = item,
                        textColor = colors.white,
                        fontSize = 22})
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
