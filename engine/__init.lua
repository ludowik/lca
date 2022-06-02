if arg[#arg] == "-debug" then require("mobdebug").start() end
function debugging()
    -- TODO
end


ffi = require 'ffi'

require 'lua'
require 'lua_collection'
require 'maths'
require 'graphics'

require 'scene.node'
require 'scene.scene'

require 'engine.app'
require 'engine.love'
require 'engine.config'
require 'engine.engine'
require 'engine.event'
require 'engine.gesture'
require 'engine.parameter'
require 'engine.physics'
require 'engine.fs'
require 'engine.path'
require 'engine.sound'
require 'engine.keyboard'
--require 'engine.package'

json = require 'lib/json'
utf8 = require 'lib/utf8'
sfxr = require 'lib/sfxr'

io.read = function (name)
    local info = love.filesystem.getInfo(name)
    if info then
        return love.filesystem.read(name)
    end
    return nil
end

io.write = love.filesystem.write

output = class 'Output'

function Output.clear()
end

