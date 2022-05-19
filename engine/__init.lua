if arg[#arg] == "-debug" then require("mobdebug").start() end

require 'lua'
require 'lua_collection'

require 'graphics.window'
require 'graphics.transform'
require 'graphics.styles'
require 'graphics.color'
require 'graphics.graphics2d'
require 'graphics.graphics2d_love'
require 'graphics.graphics2d_core'
require 'graphics.shape'
require 'graphics.model'

require 'engine.app'
require 'engine.love'
require 'engine.config'
require 'engine.engine'
require 'engine.gesture'

require 'engine.scene'
require 'engine.parameter'

io.read = function (name)
    local info = love.filesystem.getInfo(name)
    if info then
        return love.filesystem.read(name)
    end
    return nil
end

io.write = love.filesystem.write