function getOS()
    return love.system.getOS():lower():gsub(' ', '')
end

os.name = getOS() == 'ios' and 'ios' or 'ios-osx'

love.filesystem.setRequirePath(
    '?/#.lua;'..
    '?/__init.lua;'..
    '?/main.lua;'..
    '?/!.lua;'..
    love.filesystem.getRequirePath())

function getFontPath()
    return 'res/fonts'
end

function getHomePath()
    if windows then
        return os.getenv('USERPROFILE')
    else
        return '/Users/Ludo'
--        return os.getenv('HOME')
    end
end

require 'lua'
require 'lua_collection'
require 'maths'

json = require 'lib/json'
utf8 = require 'lib/utf8'
sfxr = require 'lib/sfxr'

requireLib(
    'codea',
    'window',
    'app',
    'appManager',
    'db',
    'fps',
    'console',
    'parameter',
    'sound',
    'event',
    'run',
    'package',
    'keyboard',
    'fs',
    'timer',
    'introspection',
    'gesture',
    'path',
    'resourceManager'
)

require 'graphics'
require 'scene'
require 'ui'
require 'physics'

require 'libc.library'
require 'libc/sdl'
require 'libc/openal'

Sdl()
-- OpenAL()

