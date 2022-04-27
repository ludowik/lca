function class(name)
    local k = {}

    function new(k)
        local t = setmetatable({}, k)
        k.__index = k
        return t
    end

    -- inheritance
    k.extends = function (k, ...)
        k.__bases = {...}
        for _,base in ipairs(k.__bases) do
            for name,value in pairs(base) do
                if type(value) == 'function' then
                    if not k[name] then
                        k[name] = value
                    end
                end
            end
        end
        return k
    end
    
    setmetatable(k, {
        __call = function(k, ...)
            local instance = new(k)
            return instance:init(...) or instance
        end
    })

    if name and type(name) == 'string' then
        _G[name] = k
    end

    return k
end
