NL = '\n'

function string:inList(list, ...)
    if type(list) ~= 'table' then
        list = {list, ...}
    end
    for _,str in ipairs(list) do
        if self == str then
            return true
        end
    end
end

function string.contains(s, ...)
    local args = {...}
    if #args == 1 and type(args[1]) == 'table' then
        args = args[1]
    end

    for i,v in ipairs(args) do
        if s:find(v) then
            return true
        end
    end
    return false
end

function string:startWith(text)
    return self:find(text) == 1
end

string.__format = string.format

function string.format(str, args, ...)
    if type(args) == 'table' then
        for i,v in ipairs(args) do
            str = str:gsub('{'..i..'}', tostring(v))
        end
        for k,v in pairs(args) do
            str = str:gsub('{'..k..'}', tostring(v))
        end
        return str
    end

    return string.__format(str, args, ...)
end

function string.left(s, n)
    return s:sub(1, n)
end

function string.mid(s, i, n)
    if n then
        return s:sub(i, i+n-1)
    else
        return s:sub(i)
    end
end

function string.right(s, n)
    return s:sub(-n)
end

function string.replace(s, from, to)
    local s = s:gsub(from, to)
    return s
end

function string.split(s, delimiter_, trim)
    trim = trim == nil and true or trim

    local result = table() or {}
    local delimiter = delimiter_ or ","
    if delimiter == '.' then
        delimiter = '%.'
    end
    for match in (s..delimiter_):gmatch("(.-)"..delimiter) do
        if trim then
            match = match:trim()
        end
        table.insert(result, match)
    end
    return result
end

function string.join(tab, delimiter)
    local result = ""
    for i,s in ipairs(tab) do
        result = result..tostring(s)..delimiter
    end
    return result
end

function string.tab(level)
    local str = ''
    for i=1,level do
        str = str..'    '
    end
    return str
end

function string.trim(s)
    while string.find(s, "  ") do
        s = string.gsub(s, "  ", " ")
    end
    return s:match'^()%s*$' and '' or s:match'^%s*(.*%S)'
end

function string.proper(s)
    s = s:sub(1, 1):upper() .. s:sub(2):lower()
    return s
end

function string.findLast(s, txt)
    s = s:reverse()
    local i = s:find(txt)
    if i then
        return s:len() - i + 1
    end
end

class('__string')

__string.test = function ()
    ut.assert('lower', string.lower('TEST') == 'test')
    ut.assert('upper', string.upper('test') == 'TEST')

    ut.assert('left', string.left('test', 2) == 'te')
    ut.assertEqual('right', string.right('right', 2), 'ht')

    ut.assert('rep', string.rep('t', 4) == 'tttt')

    ut.assert('proper', string.proper('test test') == 'Test test')

    ut.assert('startWith=true', string.startWith('test', 'te') == true)
    ut.assert('startWith=false', string.startWith('test', 'et') == false)

    ut.assert('contains=true', string.contains('test', 'es') == true)
    ut.assert('contains=false', string.contains('test', 'et') == false)

    ut.assert('replace', string.replace('test', 'e', 'E') == 'tEst')
    
    ut.assert('repeat', string.rep('a', 5) == 'aaaaa')
    ut.assert('repeat', string.rep('ab', 2) == 'abab')
end