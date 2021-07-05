if arg[#arg] == "-debug" then
    require("mobdebug").start()
end

local path = '?/#.lua;'..love.filesystem.getRequirePath()
love.filesystem.setRequirePath(path)

require 'lua'
require 'lua_collection'

require 'engine.graphics'
require 'engine.color'
require 'engine.event'
require 'engine.window'
require 'engine.fps'
require 'engine.console'
require 'engine.run'

os.name = love.system.getOS():lower():gsub(' ', '')

if os.name == 'osx' then
    os.execute('zip -1 -r -u lca.love . -x "*.git*" "*.DS_Store*"')
end
