classes = {}

function class(name)
    local k = {}
    k.__index = k
    
    table.insert(classes, k)

    setmetatable(k, { 
            __call = function(_, ...)
                local instance = setmetatable({}, k)
                return k.init(instance, ...) or instance
            end
        })

    _G[name] = k
    return k
end

function setupClasses()
    for k,v in ipairs(classes) do
        if v.setup then
            v.setup()
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
