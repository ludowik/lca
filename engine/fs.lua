function dir(path, fileType)
    local list = table()
    for i,item in ipairs(love.filesystem.getDirectoryItems(path)) do
        if not item:lower():contains('.ds_store') and 
           not item:lower():contains('.git') then
            local info = love.filesystem.getInfo(path..'/'..item)
            if fileType == nil or info.type == fileType then
                list:add(path..'/'..item)
            end
        end
    end
    return list
end

function enum(path, list)
    list = list or table()
    for i,item in ipairs(love.filesystem.getDirectoryItems(path)) do
        local subPath = (#path > 0 and path..'/'..item) or item
        if isApp(subPath) then
            list:add(subPath)
        else
            local info = love.filesystem.getInfo(subPath)
            if info.type == 'directory' then
                enum(subPath, list)            
            end
        end
    end
    return list
end

function splitPath(path)
    local j = path:findLast('/')

    local name = j and path:sub(j+1) or path
    local directory = j and path:sub(1, j) or ''

    return directory, name
end

function splitFilePath(strFilename)
    -- Returns the Path, Filename, and Extension as 3 values
    local info = love.filesystem.getInfo(strFilename)
    if info and info.type == 'directory' then
        local directory, name = splitPath(strFilename)
        return directory, name, ''
    end
    strFilename = strFilename..'.'
    return strFilename:match('^(.-)([^\\/]-)%.([^\\/%.]-)%.?$')
end

function isApp(path)
    if isFile(path..'/'..'Info.plist') then
        return true
    end

    local info = love.filesystem.getInfo(path)
    if info and info.type == 'file' then
        if path:lower():contains('.lua') then
            return true
        end
        return false
    end

    return moduleExist(path)
end

function isDirectory(path)
    local info = love.filesystem.getInfo(path)
    if info and info.type == 'directory' then
        return true
    end
end

function isFile(path)
    local info = love.filesystem.getInfo(path)
    if info and info.type == 'file' then
        return true
    end
end

function isLuaFile(path)
    return isFile(path) and path:lower():contains('.lua')
end

function getCurrentDir()
    return love.filesystem.getWorkingDirectory()
end

function makeDir(path)
    love.filesystem.createDirectory(path)
end
