local logs = table()

local __print = __print or print

function print(...)
    __log(...)
    __print(...)
    
    io.flush()
end

function log(...)
    print(...)
end

function __log(...)
    local t = table()
    for i,v in ipairs({...}) do
        t[i] = tostring(v)
    end
    
    local text = t:concat('  ') or ''

    if not logs[text] then
        logs[text] = {
            count = 0,
            text = text
        }
        logs:insert(logs[text])
    end

    logs[text].count = logs[text].count + 1
end

function implement(...)
    return log(...)
end
