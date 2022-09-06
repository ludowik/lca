love.filesystem.setRequirePath('?.lua;?/__init.lua')

ffi = love and require 'ffi' or nil

json = require 'lib/json'
utf8 = require 'lib/utf8'
sfxr = require 'lib/sfxr'

require 'lua.debug'
require 'lua'
require 'lua_collection'
require 'maths'
require 'graphics'
require 'scene'
require 'physics'

requireLib(
    'apps',
    'application',
    'config',
    'engine',
    'event',
    'gesture',
    'parameter',
    'fs',
    'path',
    'sound',
    'keyboard',
    'framework',
    'package',
    'speech')

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
