class 'Log'

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

function Log.draw(x, y)
    pushMatrix()
    do
        if x then translate(x, y) end
        
        local n = #logs
        local start = max(1, n-25)
        for i=start,n do
            local log = logs[i]
            text(log.count..' '..log.text)
        end
    end
    popMatrix()
end

output = class 'Output'

function Output.clear()
    logs = table()
end
