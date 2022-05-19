local apps = {
    listByName = {},
    listByIndex = {},
}

function loadApps()
    local files = love.filesystem.getDirectoryItems('apps')
    for _,file in ipairs(files) do
        loadApp(file:gsub('.lua', ''))
    end
end

function loadApp(name)
    if not apps.listByName[name] then
        local env = setmetatable({}, {__index = _G})

        local info = (
            love.filesystem.getInfo('apps/' .. name .. '.lua') or
            love.filesystem.getInfo('apps/' .. name))
        
        if info then
            _G.env = env
            setfenv(0, env)
                
            local chunk
            if info.type == 'file' then
                chunk = love.filesystem.load('apps/' .. name .. '.lua')
            else
                chunk = love.filesystem.load('apps/' .. name .. '/init.lua')
            end
            assert(chunk)

            if chunk then
                pcall(chunk, env)
                
                env.app = env
                env.appName = name
                
                callApp('setup')
                
                apps.listByName[name] = {
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
                setApp(index)
                break
            end
        end
    end
end

function setApp(index)
    apps.current = index
    
    local env = apps.listByIndex[apps.current].env
    _G.env = env
    
    local name = apps.listByIndex[apps.current].name
    config.appName = name
    love.window.setTitle(name)
    
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
