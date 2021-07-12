table.__index = table
table.add = table.insert

local mt = {
    __call = function (_, t)
        t = t or {}
        setmetatable(t, table)
        return t
    end
}
setmetatable(table, mt)

table.add = table.insert

function table:clone()
    local copy = table()
    for i,v in ipairs(self) do
        copy[i] = v
    end
    for k,v in pairs(self) do
        copy[k] = v
    end
    return copy
end

function table:attribs(attribs)
    for k,v in pairs(attribs) do
        self[k] = v
    end
    return self
end

function table:random()
    if #self > 0 then
        return self[love.math.random(#self)]
    end
end

function table:call(name, ...)
    for i,v in ipairs(self) do
        if type(v) == 'table' and v[name] then
            v[name](v, ...)
        end
    end
    return self
end

function table:concat(sep)
    assert(sep)
    local str
    for i,v in ipairs(self) do
        if not str then
            str = tostring(v)
        else
            str = str..sep..tostring(v)
        end
    end
    return str
end

function table:removeItem(item)
    for i,v in ipairs(self) do
        if v == item then
            return self:remove(i)
        end
    end
end

function table:tolua()
    local str = '{'
    for k,v in pairs(self) do
        str = str..NL..k..' = '..tostring(v)..','
    end
    str = str..NL..'}'
    return str
end
