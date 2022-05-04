if love then
    function io.read(path)
        path = path:gsub('%./', '')
        local content, size = love.filesystem.read(
            path)
        return content
    end

    function io.write(path, content, mode)
        path = path:gsub('%./', '')
        local success, message
        if mode == 'at' then 
            success, message = love.filesystem.append(path, content)
        else
            success, message = love.filesystem.write(path, content)
        end
        assert(success, message)
        return success
    end

else
    function io.read(path)
        local file = io.open(path, 'r')
        if file then
            local content = file:read('*a')
            file:close()
            return content
        end
    end

    function io.write(path, content, mode)
        local file = io.open(path, mode or 'wt')
        if file then
            local success, message = file:write(content)
            assert(success, message)
            file:close()
            return success
        end
    end
end
