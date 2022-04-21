apps = {
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
        assert(pcall(setfenv(love.filesystem.load('apps/' .. name .. '.lua'), env)))
        apps.listByName[name] = {
            name = name,
            env = env,
        }
        apps.listByIndex[#apps.listByIndex + 1] = apps.listByName[name]
    end
    _G.env = apps.listByName[name].env
    for index=1,#apps.listByIndex do
        if apps.listByIndex[index] == apps.listByName[name] then
            apps.current = index
            break
        end
    end
end

function setApp(index)
    apps.current = index
    _G.env = apps.listByIndex[apps.current].env
    call('setup')
end

function previousApp()
    setApp((apps.current + #apps.listByIndex - 2) % #apps.listByIndex + 1)
end

function nextApp()
    setApp(apps.current % #apps.listByIndex + 1)
end

function randomApp()
    setApp(random(#apps.listByIndex))
end
