Apps = table()

function loadApp(path)
    if Apps[path] then
        setActiveApp(Apps[path])
        return
    end

    local default = function () end

    local env = {
        setup    = default,
        update   = default,
        draw     = default,
        keyboard = default,
        touched  = default,
    }

    setmetatable(env, {__index=_G})
    setfenv(0, env)

    require(path)

    env.env = env
    app = {
        name = path
    }
    parameter = Parameter()

    env.win = Window(env, 0, 0)    

    W = env.win.position.w
    H = env.win.position.h

    Apps:insert(env)
    Apps[path] = env

    setActiveApp(env)

    env.win:setupInstance()    

    return env
end

function setActiveApp(env)
    WindowsManager.windows:insert(WindowsManager.windows:removeItem(env.win))
    _G.env = env
    setfenv(0, env)
end

function nextApp()
    local app = Apps[#Apps]
    setActiveApp(app)
end

function previousApp(env)
    local app = Apps[1]
    setActiveApp(app)
end
