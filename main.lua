require 'engine.engine'

apps = {
    listByName = {},
    listByIndex = {},
}

function loadApp(name)
    if not apps.listByName[name] then
        local env = setmetatable({}, {__index = _G})
        assert(pcall(loadfile('apps/' .. name .. '.lua', 't', env)))
        apps.listByName[name] = {
            name = name,
            env = env,
            index = #apps.listByIndex + 1
        }
        apps.listByIndex[#apps.listByIndex + 1] = apps.listByName[name]
    end
    _G.env = apps.listByName[name].env
    apps.current = apps.listByName[name].index
end

function previousApp()
    apps.current = (apps.current + #apps.listByIndex - 2) % #apps.listByIndex + 1
    _G.env = apps.listByIndex[apps.current].env
    call('setup')
end

function nextApp()
    apps.current = apps.current % #apps.listByIndex + 1
    _G.env = apps.listByIndex[apps.current].env
    call('setup')
end

loadApp('primitives')
loadApp('falling_square')
loadApp('blinking_circle')
