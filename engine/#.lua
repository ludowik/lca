if arg[#arg] == "-debug" then
    require("mobdebug").start()
end

os.name = love.system.getOS():lower():gsub(' ', '')

local path = '?/#.lua;'..love.filesystem.getRequirePath()
love.filesystem.setRequirePath(path)

os.name = love.system.getOS():lower():gsub(' ', '')

require 'lua'
require 'lua_collection'

require 'engine.graphics'
require 'engine.color'
require 'engine.event'
require 'engine.rect'
require 'engine.window'
require 'engine.tween'
require 'engine.db'
require 'engine.fps'
require 'engine.console'
require 'engine.run'

if os.name == 'osx' then
    os.execute('zip -1 -r -u lca.love . -x "*.git*" "*.DS_Store*"')
end
