local mt = {
    __call = function (_, t)
        t = t or {}
        setmetatable(t, table)
        return t
    end
}
setmetatable(table, mt)

table.__index = table

function table:clone()
    local function clone(self)
        if type(self) == 'table' then
            local copy = table()
            for i,v in ipairs(self) do
                copy[i] = clone(v)
            end
            for k,v in pairs(self) do
                copy[k] = clone(v)
            end
            return copy
        else
            return self
        end
    end
    return clone(self)
end

function table.random(array)
    local n = #array
    local r = math.random(n)
    return array[r]
end

table.add = table.insert

table.push = table.insert
table.pop = table.remove

function table:tolua(level)
    if not self then return '' end

    level = level or 1
    local function tab(level)
        return string.rep('    ', level)
    end

    local t = ''
    for k,v in pairs(self) do
        local val
        local typeof = type(v)
        if typeof == 'string' then
            val = '"' .. v .. '"'

        elseif typeof == 'boolean' then
            val = v and 'true' or 'false'

        elseif typeof == 'table' then
            val = table.tolua(v, level+1)

        else
            val = tostring(v)
        end
        t = t .. tab(level) .. k .. ' = ' .. val .. ',\n'
    end
    return '{\n' .. t .. tab(level-1) .. '}'
end
