local __classes = table()
local __classesByName = table()

function class(className)
    local k = {}
    k.__index = k
    
    local mt = table()
    function mt.__call(k, ...)
        local instance = {}
        setmetatable(instance, k)
        instance = k.init(instance, ...) or instance
        return instance
    end

    setmetatable(k, mt)

    k.init = function () end

    k.extends = function (k, ...)
        k.__bases = {...}
        k.super = k.__bases[1].init
        for _,base in ipairs(k.__bases) do
            for name,value in pairs(base) do
                if not k[name] then
                    k[name] = value
                end
            end
        end
        return k
    end
    
    k:extends(table)

    _G[className] = k

    __classesByName[className] = k
    __classes:insert(k)    

    return k
end

function setupClasses()
    __classes:call('setup')
end
