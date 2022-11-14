class 'Log'

local logs = table()

local __print = __print or print

function print(...)
    __log(...)
    __print(...)

    io.flush()
end

function log(...)
    local level = 3
    print('Log: '..__FILE__(level)..':'..__LINE__(level)..': '..__FUNC__(level)..' => ', ...)
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
        
        textMode(CORNER)

        local n = #logs
        local start = 1
        for i=n,start,-1 do
            local log = logs[i]
            text(log.count..' '..log.text)
            if textPosition() > (screenConfig.H-y) then
                break
            end
        end
    end
    popMatrix()
end

output = class 'Output'

function Output.clear()
    logs = table()
end
