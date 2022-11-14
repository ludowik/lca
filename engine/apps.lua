local apps = {
    listByName = {},
    listByIndex = {},
}

global.appsList = apps

function getnApps()
    return #apps.listByIndex
end

function addApps(path)
    if app == nil then
        addAppOfTheApps()
    end

    path = path or APPS

    local files = dir(path)
    files:sort()

    for _,ref in ipairs(files) do
        local _path, file = splitPath(ref)

        if (file:lower():contains('.ds_store') or 
            file:lower():contains('.git'))
        then
            -- continue

        elseif isApp(path..'/' .. file) then
            addApp(path, file:gsub('.lua', ''))

        else
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
        apps.listByName[filePath].index = #apps.listByIndex
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

    package.loaded = {}

    addApps()
end

function addAppOfTheApps()
    addApp('apps', 'apps')
end

function loadAppOfTheApps()
    return loadApp('apps', 'apps')
end

function loadApp(path, name, garbage)
    if not path then
        loadAppOfTheApps()
        return
    end

    if garbage then
        gc()
    end

    local filePath, ext
    if not name then
        path, name, ext = splitPath(path or '')
        if name then
            filePath = path..'/'..name
        else
            filePath = path
        end
    else
        filePath = path..'/'..name
    end

    if not apps.listByName[filePath] then
        loadAppOfTheApps()
        return
    end

    callApp('pause')

    if not apps.listByName[filePath].loaded then
        log('load app : '..path..'/'..name)
    else
        log('set active app : '..name)
    end

    apps.currentIndex = apps.listByName[filePath].index

    if not apps.listByName[filePath].loaded then        
        apps.listByName[filePath].loaded = true

        path = apps.listByName[filePath].path
        name = apps.listByName[filePath].name

        local env = {
            __vsync = 1,

            setup = function () end,

            draw = function ()
                background()
                local scene = env.scene or env.ui
                if scene then
                    scene:draw()
                end
            end,

            touched = function (touch)
                local scene = env.scene or env.ui
                if scene then
                    scene:touched(touch)
                end
            end,
        }

        setmetatable(env, {__index = _G})

        -- TODO : sipmlify the compute of the file entry
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
                local info = getInfoPath(path..'/' .. name)
                chunk = love.filesystem.load(info.path)
            end
            assert(chunk, path, name)

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

                setOrientation()

                apps.listByName[filePath].env = env
            end
        end

    else
        local env = apps.listByIndex[apps.currentIndex].env
        _G.env = env
        setfenv(0, env)

        setOrientation()

        callApp('resume')
    end

    love.window.setTitle(name)

    config.appPath = _G.env.appPath
    config.appName = _G.env.appName

    saveConfig()

    love.window.setVSync(not not _G.env.__vsync)

    return _G.env
end

-- load app
function loadAppCodea(dir, name, isDependencies)    
    local path = dir..'/'..name
    local content = love.filesystem.read(path..'/'..'Info.plist')

    if not content then assert(false, path) end

    -- loading dependencies
    if not isDependencies then
        local block = content:match('<key>Dependencies</key>.-<array>(.-)</array>')
        if block then
            for v in block:gfind('<string>(.-)</string>') do
                --                v = v:gsub('Documents:', '')

                local links = v:split(':')
                loadAppCodea(dir, links[#links], true)
            end
        end
    end

    -- loading projects
    local block = content:match('<key>Buffer Order</key>.-<array>(.-)</array>')
    if block then
        for v in block:gfind('<string>(.-)</string>') do
            if not isDependencies or v:lower() ~= 'main' then
                package.loaded[path..'/'..v] = nil
                require(path..'/'..v)
            end
        end
    end
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
    local index = randomInt(#apps.listByIndex)
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
        if _G.env.app and _G.env.app[fname] then 
            return _G.env.app[fname](_G.env.app, ...)
        elseif _G.env[fname] then 
            return _G.env[fname](...)
        end
    end
    return false
end
