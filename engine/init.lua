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
    'keyboard',
    'framework',
    'package')
