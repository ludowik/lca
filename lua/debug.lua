local inDebugging = false

function debugging() return inDebugging end

-- function debugStart()
--     inDebugging = true
--     local debug = require 'lib/mobdebug/mobdebug'
--     debug.start()
--     debug.coro()
--     debug.on()
-- end

-- function debugStop(check)
--     if not check then return end

--     inDebugging = true
--     local debug = require 'lib/mobdebug/mobdebug'
--     debug.start()
--     debug.on()
--     debug.pause()
-- end

if arg[#arg] == "vsc_debug" then
    local lldebugger = require "lldebugger"
    lldebugger.start()

    debugMode = true

    local run = love.run
    function love.run(...)
        local f = lldebugger.call(run, false, ...)
        return function(...)
            return lldebugger.call(f, false, ...)
        end
    end
end
-- if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
--     print("start lldebugger")
--     require("lldebugger").start()
-- end

if arg[#arg] == "-debug" then
    --debugStart()
end

function __FILE__(level)
    return debug.getinfo(level or 1, 'S').source or 'unknown file'
end

function __LINE__(level) return debug.getinfo(level or 1, 'l').currentline or 'unknown line' end

function __FUNC__(level) return debug.getinfo(level or 1).name or 'unknown function' end

function getFileLocation(msg, level)
    level = 3 + (level or 1)

    if __FUNC__(level) then
        msg = msg and tostring(msg) or ''

        local file = __FILE__(level) or ''
        local line = __LINE__(level) or ''

        return file .. ':' .. line
    end
end

function getFunctionLocation(msg, level)
    level = level or 0

    local fileLocation = getFileLocation(msg, level + 2)
    if fileLocation then
        msg = msg and tostring(msg) or ''

        local func = __FUNC__(level + 4) or ''

        return fileLocation .. ': ' .. msg .. ' ' .. func
    end
end
