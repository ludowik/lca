classes = {
    list = {}
}

function classes.setup()
    for i=1,#classes.list do
        local k = classes.list[i]
        classWithProperties(k)
        
        if k.setup then
            k.setup()
        end
        
        if k.test then
            k.test()
        end
    end
    classes.list = table()
end

function class(className, ...)
    assert(className and type(className) == 'string')

    local k = table()
    k.__index = k
    k.__className = className

    table.insert(classes.list, k)

    setmetatable(k, { 
            __call = function(_, ...)
                local instance = setmetatable({}, k)
                return k.init(instance, ...) or instance
            end,
        })

    k.init = nilf

    -- extends
    function k.extends(...)
        local bases = {...}
        for _,base in pairs(bases) do
            for name,f in pairs(base) do
                if type(f) == 'function' then
                    if not k[name] or (name == 'init' and k[name] == nilf) then
                        k[name] = f
                    end
                end
            end
        end
        return k
    end

    k.extends(...)

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
        local store = getfenv(0)
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
        print(proto.__className..' have properties')
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

function push2_G(meta)
    for k,f in pairs(meta) do
        if k ~= 'setup' and k ~= 'init' and type(f) == 'function' then 
            (global or _G)[k] = f
        end
    end
end

function classnameof(object)
    return attributeof('__className', object)
end

function attributeof(attrName, object)
    global.__object__ = object
    return evalExpression('global.__object__.'..attrName)
end

function typeof(object)
    local typeof = type(object)
    if typeof == 'table' then
        return classnameof(object) or 'table'

    elseif typeof == 'cdata' then
        typeof = ffi.typeof(object)
        if typeof then
            return typeof
        end
        return 'cdata'
    end
    return typeof
end
