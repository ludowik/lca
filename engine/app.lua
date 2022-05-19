local apps = {
    listByName = {},
    listByIndex = {},
}

function loadApps(path)
    path = path or 'apps'
    local files = love.filesystem.getDirectoryItems(path)
    for _,file in ipairs(files) do
        local info = (
            love.filesystem.getInfo(path..'/' .. file .. '/init.lua') or
            love.filesystem.getInfo(path..'/' .. file))

        if info.type == 'file' then
            loadApp(path, file:gsub('.lua', ''))

        elseif info.type == 'directory' then
            loadApps(path..'/'..file)

        end
    end
end

function loadApp(path, name)
    path = path or 'apps'
    log('load '..path..'/'..name)

    if not apps.listByName[name] then
        local env = setmetatable({}, {__index = _G})

        local info = (
            love.filesystem.getInfo(path..'/' .. name .. '.lua') or
            love.filesystem.getInfo(path..'/' .. name))

        if info then
            _G.env = env
            setfenv(0, env)

            local chunk
            if info.type == 'file' then
                chunk = love.filesystem.load(path..'/' .. name .. '.lua')
            else
                chunk = love.filesystem.load(path..'/' .. name .. '/init.lua')
            end
            assert(chunk)

            if chunk then
                pcall(chunk, env)

                env.app = env
                env.appPath = path
                env.appName = name

                env.parameter = Parameter()

                callApp('setup')

                apps.listByName[name] = {
                    path = path,
                    name = name,
                    env = env,
                }
                apps.listByIndex[#apps.listByIndex + 1] = apps.listByName[name]
            end
        end
    end

    if apps.listByName[name] then
        for index=1,#apps.listByIndex do
            if apps.listByIndex[index] == apps.listByName[name] then
                apps.current = index
                local env = apps.listByIndex[apps.current].env
                _G.env = env
                break
            end
        end
    end
end

function setApp(index)
    apps.current = index

    local env = apps.listByIndex[apps.current].env
    _G.env = env

    local app = apps.listByIndex[apps.current]
    config.appPath = app.path
    config.appName = app.name

    love.window.setTitle(app.name)

    saveConfig()
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
