--local http = require 'https'
--local response = http.send('https://ludowik.github.io/lca/build/love/lca.love')
--print(response.code, response.body)
--love.filesystem.write('lca.love', response.body)
--love.filesystem.mount('lca.love', '', false)

require 'engine'
