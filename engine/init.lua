if arg[#arg] == "-debug" then require("mobdebug").start() end

require 'lua.os'
require 'lua.class'
require 'lua.math'
require 'lua.random'
require 'lua.string'
require 'lua.vec2'
require 'lua.vec3'
require 'lua.vec4'
require 'lua.rect'
require 'lua.table'
require 'lua.grid'
require 'lua.require'
require 'lua.log'

require 'graphics.window'
require 'graphics.transform'
require 'graphics.styles'
require 'graphics.color'
require 'graphics.graphics2d'
require 'graphics.graphics2d_love'
require 'graphics.graphics2d_core'
require 'graphics.shape'

require 'engine.app'
require 'engine.love'
require 'engine.config'
require 'engine.engine'

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