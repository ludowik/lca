local classes = {}

function class(name)
    local k = {}
    k.__index = k

    table.insert(classes, k)

    setmetatable(k, { 
            __call = function(_, ...)
                local instance = setmetatable({}, k)
                return k.init(instance, ...) or instance
            end,
        })

    function k.extends(...)
        extends(...)
    end

    _G[name] = k
    return k
end

function extends(k, ...)
    local bases = {...}
    assert(#bases >= 1)
    for _,base in pairs(bases) do
        for name,f in pairs(base) do
            if type(f) == 'function' then
                k[name] = f
            end
        end
    end
end

function setupClasses()
    for i=1,#classes do
        local k = classes[i]
        if k.setup then
            k.setup()
            k.__setupDone = k.setup
            k.setup = nil
        end
    end
end

function push2_G(meta)
    for k,f in pairs(meta) do
        if k ~= 'setup' and k ~= 'init' and type(f) == 'function' then 
            _G[k] = f
        end
    end
end
