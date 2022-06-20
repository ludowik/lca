local apps = {
    listByName = {},
    listByIndex = {},
}

function getnApps()
    return #apps.listByIndex
end

function addApps(path)
    path = path or 'apps'

    local files = love.filesystem.getDirectoryItems(path)
    for _,file in ipairs(files) do
        local info = (
            love.filesystem.getInfo(path..'/' .. file .. '/#.lua') or
            love.filesystem.getInfo(path..'/' .. file .. '/init.lua') or
            love.filesystem.getInfo(path..'/' .. file .. '/__init.lua') or
            love.filesystem.getInfo(path..'/' .. file .. '/main.lua') or
            love.filesystem.getInfo(path..'/' .. file))

        if info.type == 'file' then
            addApp(path, file:gsub('.lua', ''))

        elseif info.type == 'directory' then
            addApps(path..'/'..file)

        end
    end
end

function addApp(path, name)
    if not apps.listByName[name] then
        log('add app : '..path..'/'..name)

        apps.listByName[name] = {
            loaded = false,
            path = path,
            name = name
        }
        apps.listByIndex[#apps.listByIndex + 1] = apps.listByName[name]
    end
end

function resetApps()
    for i,_ in ipairs(apps.listByIndex) do
        apps.listByIndex[i] = nil
    end
    for k,_ in pairs(apps.listByName) do
        apps.listByName[k] = nil
    end
    
    apps = nil
end

function loadApp(path, name)
    log('load app : '..path..'/'..name)
    path = path or 'apps'

    assert(apps.listByName[name])

    if not apps.listByName[name].loaded then
        apps.listByName[name].loaded = true

        path = apps.listByName[name].path
        name = apps.listByName[name].name

        local env = {
            __vsync = 1
        }

        setmetatable(env, {__index = _G})

        local info = (
            love.filesystem.getInfo(path..'/' .. name .. '.lua') or
            love.filesystem.getInfo(path..'/' .. name))

        if info then
            global.env = env
            setfenv(0, env)

            loop()

            local chunk
            if info.type == 'file' then
                chunk = love.filesystem.load(path..'/' .. name .. '.lua')
            else
                chunk = (
                    love.filesystem.load(path..'/' .. name .. '/#.lua') or
                    love.filesystem.load(path..'/' .. name .. '/init.lua') or
                    love.filesystem.load(path..'/' .. name .. '/__init.lua') or
                    love.filesystem.load(path..'/' .. name .. '/main.lua'))
            end
            assert(chunk)

            if chunk then
                chunk()

                env.appPath = path
                env.appName = name

                classes.setup()

                env.parameter = Parameter()
                env.tweensManager = TweensManager()

                callApp('setup')

                apps.listByName[name].env = env
            end
        end
    end

    if apps.listByName[name] then
        for index=1,#apps.listByIndex do
            if apps.listByIndex[index] == apps.listByName[name] then
                apps.current = index
                local env = apps.listByIndex[apps.current].env
                _G.env = env
                love.window.setVSync(_G.env.__vsync)
                break
            end
        end
    end
end

function setApp(index, garbage)
    if garbage then
        gc()
    end

    local app = apps.listByIndex[index]
    config.appPath = app.path
    config.appName = app.name

    saveConfig()

    loadApp(app.path, app.name)

    apps.current = index

    local env = app.env
    _G.env = env
    setfenv(0, env)

    love.window.setTitle(app.name)
    log('set active app : '..app.name)
end

function previousApp()
    setApp((apps.current + #apps.listByIndex - 2) % #apps.listByIndex + 1)
end

function nextApp()
    setApp(apps.current % #apps.listByIndex + 1)
end

function randomApp()
    local index = random(#apps.listByIndex)
    print(index)
    setApp(index)
end

function callApp(fname, ...)
    if _G.env and _G.env[fname] then 
        return _G.env[fname](...)
    end
end

