local http = require 'socket.http'
local res, content = http.request('https://ludowik.github.io/lca/build/love/lca.love')
print(res, content)
love.filesystem.write('lca.love', content)
love.filesystem.mount('lca.love', '')

require 'engine'
