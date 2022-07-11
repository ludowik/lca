if arg[#arg] == "-debug" then require("mobdebug").start() end
function debugging()
    -- TODO
end

ffi = love and require 'ffi' or nil

require 'lua'
require 'lua_collection'
require 'maths'
require 'graphics'

require 'scene'

requireLib(
    'apps',
    'application',
    'config',
    'engine',
    'event',
    'gesture',
    'parameter',
    'physics',
    'fs',
    'path',
    'sound',
    'keyboard')

json = require 'lib/json'
utf8 = require 'lib/utf8'
sfxr = require 'lib/sfxr'
