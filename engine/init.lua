love.filesystem.setRequirePath('?.lua;?/__init.lua')

print(love.filesystem.getSaveDirectory())

ffi = love and require 'ffi' or nil

json = require 'lib/json'
utf8 = require 'lib/utf8'
sfxr = require 'lib/sfxr'

require 'lua.debug'
require 'lua'
require 'lua_collection'
require 'maths'
require 'engine.config'
require 'engine.framework'
require 'graphics'
require 'scene'
require 'physics'

requireLib(
    'apps',
    'application',
--    'config',
--    'framework',
    'engine',
    'event',
    'events',
    'mouse',
    'gesture',
    'parameter',
    'fs',
    'path',
    'sound',
    'keyboard',
    'speech',
    'package')

local function __debug()
    for k,v in pairs(arg) do
        print(k,v)
    end

    if arg[#arg] == "-debug" then
        coroutine.__create = coroutine.create

        coroutine.create = function (f)
            local thread = {
                f = f,
                status = 'suspended'
            }
            return thread
        end

        coroutine.status = function (thread)
            return thread.status
        end

        coroutine.resume = function (thread, ...)
            thread.f(...)
            thread.status = 'dead'
            return true
        end
    end
end

__debug()
