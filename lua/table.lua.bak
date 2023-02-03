
niltable = {}
function nilf()
end

local mt = {
    __call = function (_, t)
        t = t or {}
        setmetatable(t, table)
        return t
    end
}
setmetatable(table, mt)

Table = table
table.__index = table

table.unpack = unpack

function table:clone()
    local function clone(self)
        if type(self) == 'table' then
            local copy = table()
            setmetatable(copy, getmetatable(self))

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

function table:clear(value)
    local n = #self
    for i=n,1,-1 do
        self[i] = value -- default is nil
    end
    return self
end

function table:random()
    local n = #self
    if n > 0 then
        local r = math.random(n)
        return self[r]
    end
end

function table:iterator(reverse)
    if not reverse then
        local i = 0
        local n = #self
        return function ()
            i = i + 1
            if i <= n then return i, self[i] end
        end

    else
        local i = #self + 1
        local n = 0
        return function ()
            i = i - 1
            if i > n then return i, self[i] end
        end
    end
end

function table:__add(t)
    local g = table()
    g:addItems(self)
    g:addItems(t)
    return g
end

function table:attribs(attribs)
    if attribs then
        for k,v in pairs(attribs) do
            self[k] = v
        end
    end
    return self
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

function table:get(i)
    return self[i]
end

function table:set(i, item)
    self[i] = item
    return self, item
end

function table:addKeys(items)
    for k,item in pairs(items) do
        self[k] = item
    end
    return self
end

function table:getnKeys()
    local n = 0
    for k,v in pairs(self) do
        n = n + 1
    end
    return n
end

function table:call(f, ...)
    local typeof = type(f)
    local n = #self
    for i=1,n do
        local v = self[i]
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
        local v = self[i]
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

function table:tostring()
    if not self then return 'nil' end

    local code = ''
    for _,iter in pairs({pairs, ipairs}) do
        for k,v in iter(self) do
            code = code..tostring(k)..' = '..tostring(v)..','..NL
        end
    end
    return code
end

function table:tolua(level, __recursive)
    if not self then return 'nil' end

    __recursive = __recursive or {}
    if __recursive[self] then return '__recursive' end
    __recursive[self] = true

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
            local className = classnameof(v)
            if className == 'Color' then
                val = 'Color('..v.r..', '..v.g..', '..v.b..', '..v.a..')'

            elseif className == 'vec2' then
                val = 'vec2('..v.x..', '..v.y..')'

            elseif className == 'vec3' then                
                val = 'vec3('..v.x..', '..v.y..', '..v.z..')'

            elseif className == 'vec4' then
                val = 'vec4('..v.x..', '..v.y..', '..v.z..', '..v.w..')'

            else
                val = table.tolua(v, level+1, __recursive)
            end

        else
            val = tostring(v)
        end

        if type(k) == 'string' then
            t = t .. tab(level) .. "['" .. k .."']" .. ' = ' .. val .. ',\n'
        else
            t = t .. tab(level) .. '[' .. k ..']' .. ' = ' .. val .. ',\n'
        end
    end

    __recursive[self] = nil

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

function table:enumerate()
    local i = 0
    local n = #self
    return function ()
        i = i + 1
        if i <= n then
            return i, self[i]
        end
        return nil
    end
end

function table:enumerateBy2()
    local i = 0
    local n = #self
    return function ()
        i = i + 1
        if i < n then
            return i, self[i], self[i+1]
        end
        return nil
    end
end

function table:enumerateBy3()
    local i = 0
    local n = #self
    return function ()
        i = i + 1
        if i < n-1 then
            return i, self[i], self[i+1], self[i+2]
        end
        return nil
    end
end

function table:first(item)
    if item then
        self.currentItem = self[table.indexOf(self, item) or 1]
    else
        self.currentItem = self[1]
    end
    return self.currentItem
end

function table:last()
    self.currentItem = self[#self]
    return self.currentItem
end

function table:current()
    return self.currentItem or self[1]
end

function table:navigate(currentItem, nextIndex, defaultIndex)
    currentItem = currentItem or self.currentItem
    nextIndex = nextIndex or 1
    defaultIndex = defaultIndex or 1

    local nextItem
    if currentItem == nil then
        nextItem = self[defaultIndex]
    else
        if type(currentItem) == 'table' and currentItem.nodes and #currentItem.nodes > 0 then
            nextItem = currentItem.nodes[1]
        else
            self = type(currentItem) == 'table' and currentItem.parent and currentItem.parent.nodes or self
            for i,v in ipairs(self) do
                if v == currentItem then
                    nextItem = self[(i+nextIndex-1)%#self+1] or self[defaultIndex]
                    break
                end
            end
        end
    end

    self.currentItem = nextItem
    return self.currentItem
end

function table:next(currentItem)
    return table.navigate(self, currentItem, 1, 1)
end

function table:previous(currentItem)
    return table.navigate(self, currentItem, -1, #self)
end

function table:concat(sep)
    sep = sep or ''

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

function table:map(f, ...)
    local map = table()
    for i=1,#self do
        map[i] = f(self, i, self[i], ...)
    end
    return map
end

function table.range(min, max, step)
    step = step or 1

    local t = Table()
    for i=1,max-min,step do
        t[i] = min+i-1
    end
    return t
end

function table:min(var)
    local v = math.maxinteger

    if var then
        for i=1,#self do
            v = __min(v, self[i][var])
        end
    else
        for i=1,#self do
            v = __min(v, self[i])
        end
    end

    return v
end

function table:max(var)
    local v = math.mininteger

    if var then
        for i=1,#self do
            v = __max(v, self[i][var])
        end
    else
        for i=1,#self do
            v = __max(v, self[i])
        end
    end

    return v
end

function table:avg(var)
    local v = 0
    local n = 0

    if var then
        for i=1,#self do
            v = v + self[i][var]
            n = n + 1
        end
    else
        for i=1,#self do
            v = v + self[i]
            n = n + 1
        end
    end

    return v / n
end

function table:extract(from)
    local t = table()
    for i=(from or 1),#self do
        t:add(self[i])
    end
    return t
end
