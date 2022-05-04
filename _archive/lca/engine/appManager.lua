function loadAppCodea(path, isDependencies)
    local content = io.read(path..'/'..'Info.plist')

    if not content then assert(false, path) end

    -- loading dependencies
    local block = content:match('<key>Dependencies</key>.-<array>(.-)</array>')
    if block then
        for v in block:gfind('<string>(.-)</string>') do
            v = v:gsub('Documents:', '')

            print('load app codea '..v..'.dependencies')
            loadAppCodea('apps/codea-apps'..'/'..v..'.codea', true)
        end
    end

    -- loading projects
    block = content:match('<key>Buffer Order</key>.-<array>(.-)</array>')
    if block then
        for v in block:gfind('<string>(.-)</string>') do
            if not isDependencies or v:lower() ~= 'main' then
                package.loaded[path..'/'..v] = nil
                require(path..'/'..v)
            end
        end
    end
end

function loadApp(path, scale, origin)
    path = path:gsub('.lua', '')

    if path == 'apps/apps' then
        scale = 1
    elseif path == 'apps/sketches2D/chaos' then
        scale = 1
    else
        scale = 1 -- scale or 1
    end

    if Apps[path] then
        print('activate app : '..path)
        setActiveApp(Apps[path])
        return app
    end

    local default = function () end

    local app = {
        setup    = default,
        update   = default,
        draw     = default,
        keyboard = default,
        touched  = default,
    }

    setmetatable(app, {__index=_G})
    setfenv(0, app)

    app.app = app
    app.appName = path

    app.win = Window(app, nil, nil, nil, nil, scale)

    app.scene = Scene()
    app.ui = UIScene()
    app.parameter = Parameter()

    app.physics = Physics()
    app.fizix = Fizix()

    --    app.scale = scale

    W = app.win.size.w
    H = app.win.size.h

    WIDTH, HEIGHT = W, H

    Apps:insert(app)
    Apps[path] = app

    if path:contains('codea/') then
        app.win.origin = app.win.origin or BOTTOM_LEFT
    else
        app.win.origin = app.win.origin or TOP_LEFT
    end

    setActiveApp(app)

    if isFile(path..'/'..'Info.plist') then
        print('load app codea '..path)
        loadAppCodea(path)
    else
        if moduleExist(path) and isApp(path) then
            print('load app : '..path)
            require(path)
        else
            require('apps/apps')
        end
    end

    setupClasses()

    if app.theapp then
        app.theapp = app.theapp()
        app.update = function (dt) app.theapp:update(dt) end
        app.draw = function () app.theapp:draw() end
    end

    app.win:setupInstance()    

    return app
end

function setActiveApp(app)
    WindowsManager.windows:insert(WindowsManager.windows:removeItem(app.win))

    _G.app = app
    _G.env = app

    setfenv(0, app)

    db.set('lca', 'appName', app.appName)
end

function navigateApp(mode)
    local apps = enum('apps'):map(function (_, _, path) return path:gsub('.lua', '') end)

    local index = apps:findItem(app.appName)
    if index then
        index = index + (mode == 'next' and 1 or -1)
        if index > #apps then index = 1 end
        if index < 1 then index = #apps end
        loadApp(apps[index])
    end
end

function nextApp()
    navigateApp('next')
end

function previousApp()
    navigateApp('previous')
end
