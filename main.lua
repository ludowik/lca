require 'engine.#'

Apps = table()

function loadApp(name, path)
    local default = function () end

    local env = {
        setup    = default,
        update   = default,
        draw     = default,
        keyboard = default
    }
    
    setmetatable(env, {__index=_G})
    setfenv(0, env)

    require(path)

    env.win = Window(env, 0, 0)
    
    W = env.win.position.w
    H = env.win.position.h

    if env.setup then
        env.setup()
    end

    Apps:insert(env)

    return env
end

function setActiveApp(env)
    _G.env = env
    setfenv(0, env)
end

function nextApp()
    local app = Apps[#Apps]
    WindowsManager.windows:insert(WindowsManager.windows:removeItem(app.win))
    
    setActiveApp(app)
end

function previousApp(env)
    local app = Apps[1]
    WindowsManager.windows:insert(WindowsManager.windows:removeItem(app.win))
    
    setActiveApp(app)
end

-- TODO : 2048, variantes
-- TODO : déplacement des fenêtres
-- TODO : sauvegarde du placement des fenêtres

-- TODO : gestion d'une base clé / valeur
