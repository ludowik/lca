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

function table:alloc(n)
    return self
end

function table:resize(n)
    return self
end

function table:reset()
    for i=1,#self do
        self[i] = nil
    end
    return self
end

table.add = table.insert

table.push = table.insert
table.pop = table.remove

function table:add(...)
    return self:addItems({...})
end

function table:addItems(items)
    for _,item in ipairs(items) do
        table.insert(self, item)
    end
    return self
end

function table:addKeys(items)
    for k,item in pairs(items) do
        self[k] = item
    end
    return self
end

function table:call(f, ...)
    local typeof = type(f)
    local n = #self
    for i=1,n do
        v = self[i]
        if typeof == "string" then
            if v[f] then
                v[f](v, ...)
            end
        elseif typeof == "function" then
            f(v, ...)
        end
    end
    return self
end

function table:call_index(f, ...)
    local typeof = type(f)
    local n = #self
    for i=1,n do
        v = self[i]
        if typeof == "string" then
            if v[f] then
                v[f](v, i, ...)
            end
        elseif typeof == "function" then
            f(v, i, ...)
        end
    end
    return self
end

function table:draw()
    self:call("draw")
end

function table:update(dt)
    self:call("update", dt)
end

function table:indexOf(item)
    for i,v in ipairs(self) do
        if v == item then
            return i
        end
    end
end

function table:findItem(item, caseInsensitive)
    local n = #self
    for i=1,n do
        local test
        if caseInsensitive then
            test = self[i]:lower() == item:lower()
        else
            test = self[i] == item
        end

        if test then
            return i, self[i]
        end
    end
end

function table:removeItem(item)
    for i,v in ipairs(self) do
        if v == item then
            return self:remove(i)
        end
    end
end

function table:chainIt()
    local n = #self
    self[1].__previous = self[n]
    self[n].__next = self[1]

    for i=1,n-1 do
        self[i].__next = self[i+1]
        self[i+1].__previous = self[i]
    end
end

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

function table.load(name)
    if love.filesystem.getInfo(name) == nil then return end

    local content = io.read(name)
    if content then
        local ftables = loadstring(content)
        return table(ftables and ftables() or nil)
    end
end

function table:save(name)
    assert(name)

    local code = 'return '..table.tolua(self)
    local file = io.write(name, code)
end
