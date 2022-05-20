local classes = {}

function class(name)
    local k = {}
    k.__index = k
    k.__className = name

    table.insert(classes, k)

    setmetatable(k, { 
            __call = function(_, ...)
                local instance = setmetatable({}, k)
                return k.init(instance, ...) or instance
            end,
        })

    function k.init()
    end

    function k.extends(...)
        local bases = {...}
        assert(#bases >= 1)
        for _,base in pairs(bases) do
            for name,f in pairs(base) do
                if type(f) == 'function' then
                    k[name] = f
                end
            end
        end
        return k
    end

    if name then
        _G[name] = k
    end
    return k
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

function classnameof(object)
    return attributeof('__className', object)
end

function attributeof(attrName, object)
    _G.__object__ = object
    return evalExpression('_G.__object__.'..attrName)
end
