local classes = {}

function class(className)
    local k = table()
    k.__index = k
    k.__className = className or 'unknown'

    table.insert(classes, k)

    setmetatable(k, { 
            __call = function(_, ...)
                local instance = setmetatable({}, k)
                return k.init(instance, ...) or instance
            end,
        })

    function k.init()
    end

    -- extends
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

    --  attribs
    k.attribs = table.attribs
    
    -- properties
    k.properties = {
        get = {},
        set = {}
    }

    -- reference
    if className then
        local classNamePath = className.split and className:split('.') or {className}
        local store = _G
        for i=1,#classNamePath-1 do
            store = store[classNamePath[i]]
        end
        store[classNamePath[#classNamePath]] = k
    end

    return k
end

function classWithProperties(proto)
    local get = proto.properties.get
    if table.getnKeys(get) > 0 then
        proto.__index = function(tbl, key)
            if proto[key] then
                return proto[key]
            elseif get[key] then
                return get[key](tbl)
            elseif type(key) == 'number' and get.index then
                return get.index(tbl, key)
            else
                return rawget(tbl, key)
            end
        end
    end

    local set = proto.properties.set
    if table.getnKeys(set) > 0 then
        proto.__newindex = function(tbl, key, value)
            if proto[key] then
                proto[key] = value
            elseif set[key] then
                set[key](tbl, value)
            elseif type(key) == 'number' and set.index then
                set.index(tbl, key, value)
            else
                rawset(tbl, key, value)
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
        
        classWithProperties(k)
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
