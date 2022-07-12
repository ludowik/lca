if love then
    io.read = function (name)
        local info = love.filesystem.getInfo(name)
        if info then
            return love.filesystem.read(name)
        end
        return nil
    end

    io.write = function(path, content, mode)
        mode = mode or 'wt'
        if mode:left(1) == 'w' then
            return love.filesystem.write(path, content)
        else
            return love.filesystem.append(path, content)
        end
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
