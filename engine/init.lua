if arg[#arg] == "-debug" then require("mobdebug").start() end

require 'lua.os'
require 'lua.class'
require 'lua.math'
require 'lua.random'
require 'lua.string'
require 'lua.vec2'
require 'lua.vec3'
require 'lua.vec4'
require 'lua.table'

require 'graphics.window'
require 'graphics.transform'
require 'graphics.styles'
require 'graphics.color'
require 'graphics.graphics2d'
require 'graphics.graphics2d_love'

require 'engine.app'
require 'engine.love'
require 'engine.config'
require 'engine.engine'
