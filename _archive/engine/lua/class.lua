classes = table()

function classes.setup()
    while #classes > 0 do
        local k = classes:remove(1)

        for key,v in pairs(_G) do
            if v == k then
                k.__className = key
            end
        end

        k.setup()
        k.test()

        k.__classInfo = k.__className
        for _,base in ipairs(k.__bases) do
            k.__classInfo = k.__classInfo..' <- ('..base.__classInfo..')'
        end
        print(k.__classInfo)
    end
end

function class(...)
    local k = {}
    k.__className = debug.getinfo(2, "Sl") or 'unknown'
    k.__index = k

    local mt = {}
    mt.__call = function (_, ...)
        local instance = table()
        setmetatable(instance, k)
        instance = k.init(instance, ...) or instance
        return instance
    end

    setmetatable(k, mt)

    k.setup = function () end
    k.init = function () end
    k.test = function () end

    k.__bases = {...}
    for _,base in ipairs(k.__bases) do
        for name,f in pairs(base) do
            if type(f) == 'function' then
                if k[name] == nil then
                    k[name] = f
                end
            end
        end
    end

    classes:insert(k)
    return k
end

interface = class
