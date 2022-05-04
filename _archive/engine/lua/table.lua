local mt = {
    __call = function (_, t)
        t = t or {}
        setmetatable(t, table)
        return t
    end
}
setmetatable(table, mt)

table.__className = 'table'
table.__classInfo = 'table'

table.__index = table

table.push = table.insert
table.pop = table.remove

table.add = table.insert

table.unpack = unpack

function table:__tostring()
    local txt = table()
    for k,v in pairs(self) do
        txt:insert(k..'='..tostring(v))
    end
    return txt:concat(',')
end
