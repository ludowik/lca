--local http = require 'https'
--local response = http.send('https://ludowik.github.io/lca/build/love/lca.love')
--print(response.code, response.body)
--love.filesystem.write('lca.love', response.body)
--love.filesystem.mount('lca.love', '', false)

--local http = require 'socket.http'
--local response = http.request('http://ludowik.github.io/lca/build/love/lca.love')
--print(response)

love.filesystem.setRequirePath(love.filesystem.getRequirePath()..';?/__init.lua')
print(love.filesystem.getRequirePath())

require 'engine'
