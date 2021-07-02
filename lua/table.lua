table.__index = table

local mt = {
        __call = function (_, t)
            t = t or {}
            setmetatable(t, table)
            return t
        end
    }
setmetatable(table, mt)

function table:random()
    if #self > 0 then
        return self[love.math.random(#self)]
    end
end

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

function table:call(name, ...)
    for i,v in ipairs(self) do
        if type(v) == 'table' and v[name] then
            v[name](v, ...)
        end
    end
end
