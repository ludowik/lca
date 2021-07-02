if arg[#arg] == "-debug" then
    require("mobdebug").start()
end

package.path = '?/__init.lua'..package.path

require 'lua'
require 'lua_collection'

require 'engine.graphics'
require 'engine.color'
require 'engine.window'
require 'engine.fps'
require 'engine.console'
require 'engine.run'
