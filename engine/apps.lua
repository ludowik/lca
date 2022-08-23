local apps = {
    listByName = {},
    listByIndex = {},
}

global.appsList = apps

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
    local filePath = path..'/'..name
    if not apps.listByName[filePath] then
        apps.listByName[filePath] = {
            loaded = false,
            path = path,
            name = name
        }
        apps.listByIndex[#apps.listByIndex + 1] = apps.listByName[filePath]
    end
end

function resetApps()
    for i,_ in ipairs(apps.listByIndex) do
        apps.listByIndex[i].imageData = nil
        apps.listByIndex[i] = nil
    end
    for k,_ in pairs(apps.listByName) do
        apps.listByName[k] = nil
    end

    apps = {
        listByName = {},
        listByIndex = {},
    }

    addApps()
end

function loadApp(path, name, garbage)
    if garbage then
        gc()
    end

    local filePath, ext
    if not name then
        path, name, ext = splitPath(path)
        if name then
            filePath = path..'/'..name
        else
            filePath = path
        end
    else
        filePath = path..'/'..name
    end

    if not apps.listByName[filePath] then
        return loadApp('apps', 'apps')
    end

    config.appPath = path
    config.appName = name

    saveConfig()

    if not apps.listByName[filePath].loaded then
        log('load app : '..path..'/'..name)
    else
        log('set active app : '..name)
    end

    if not apps.listByName[filePath].loaded then        
        apps.listByName[filePath].loaded = true

        path = apps.listByName[filePath].path
        name = apps.listByName[filePath].name

        local env = {
            __vsync = 1,
            
            setup = function () end,
            draw = function () if env.scene then env.scene:draw() end end,
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
            if isAppcodea(path..'/' .. name) then
                local code = [[
                    package.loaded['engine.codea'] = false
                    require 'engine.codea'
                    loadAppCodea('path', 'name')
                ]]                
                code = code:gsub('path', path):gsub('name', name)
                chunk = load(code)

            elseif info.type == 'file' then
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

                if isAppcodea(path..'/' .. name) then
                    classes.reset()
                else
                    classes.setup()
                end

                env.parameter = Parameter.instance()
                env.speech = Speech.instance()
                env.tweensManager = TweensManager()
                env.physics = Physics.instance()

                callApp('setup')

                apps.listByName[filePath].env = env
            end
        end
    end

    if apps.listByName[filePath] then
        for index=1,#apps.listByIndex do
            if apps.listByIndex[index] == apps.listByName[filePath] then
                apps.currentIndex = index
                local env = apps.listByIndex[apps.currentIndex].env
                _G.env = env
                setfenv(0, env)
                love.window.setVSync(_G.env.__vsync)
                break
            end
        end

        love.window.setTitle(name)
    end

    return _G.env
end

function setActiveApp(env)
    _G.env = env
    setfenv(0, env)
    love.window.setVSync(_G.env.__vsync)
end

function setApp(index, garbage)
    local app = apps.listByIndex[index]
    if app then
        return loadApp(app.path, app.name, garbage)
    end
end

function previousApp()
    return setApp((apps.currentIndex + #apps.listByIndex - 2) % #apps.listByIndex + 1)
end

function nextApp()
    return setApp(apps.currentIndex % #apps.listByIndex + 1)
end

function randomApp()
    local index = random(#apps.listByIndex)
    return setApp(index)
end

function canCallApp(fname, ...)
    if _G.env then
        if _G.env[fname] then 
            return true
        elseif _G.env.app and _G.env.app[fname] then 
            return true
        end
    end
end

function callApp(fname, ...)
    if _G.env then
        if _G.env[fname] then 
            return _G.env[fname](...)
        elseif _G.env.app and _G.env.app[fname] then 
            return _G.env.app[fname](_G.env.app, ...)
        end
    end
end
