require 'engine.engine'

apps = {}

function loadApp(name)
    local env = {}
    setmetatable(env, {__index = _G})
    local function requireApp()
        loadfile('apps/' .. name .. '.lua', env)()
    end
    setfenv(requireApp, env)
    requireApp()
    assert(env.draw)
    _G.env = env
    table.insert(apps, env)
end

function loadApp(name)
    local env = setmetatable({}, {__index=_G})
    assert(pcall(loadfile('apps/' .. name .. '.lua',"run_test_script",env)))
    _G.env = env
    table.insert(apps, env)
    return env
end

loadApp('falling_square')
loadApp('primitives')
