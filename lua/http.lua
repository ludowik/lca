local socket_http = require 'socket.http'

class('http')

function http.request(url, success, fail, parameterTable)
    local result, code, headers = socket_http.request(url)

    if result then
        local tempFile = getImagePath()
        local data = love.filesystem.write(tempFile, result)

        if headers['content-type'] and headers['content-type']:startWith('image') then
            data = image('data')
        end

        if success then 
            success(data, code, headers)
        end
        
    else        
        if fail then
            fail()
        end
    end

end
