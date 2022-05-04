function requireLib(...)
    local path = scriptPath(3)
    for i,v in pairs({...}) do
        require(path..'/'..v)
    end
end

function requirePlist(name)
    local plist = load(name)
    for res in (plist:match('<array>(.-)</array>'):gmatch('<string>(.-)</string>')) do
        require(scriptPath(3)..'/'..res)
    end
end

function scriptPath(level)
    level = level or 3
    local source = debug.getinfo(level, "S").source
    return source:match("[@]*(.+)[/\\][#_%w]+%.lua$")
end

function scriptName(level)
    level = level or 3
    local source = debug.getinfo(level, "S").source
    return source:match("(%w+)%.lua$")
end

function moduleLoader(modulepath)
    local modulename
    if modulepath:find("%/%w+$") then 
        modulename = modulepath:sub(modulepath:find("%/%w+$")+1)
    else
        modulename = modulepath
    end

    local errmsg = ""
    for path in string.gmatch(love.filesystem.getRequirePath(), "([^;]+)") do
        local filename = string.gsub(path, "%?", modulepath)
        filename = string.gsub(filename, "%!", modulename)

        local info = love.filesystem.getInfo(filename)
        if info and info.type == 'file' then

            if splitPath then
                local path, filename = splitPath(filename)
                local enum = love.filesystem.getDirectoryItems(path)
                local findIt = false
                for i,app in ipairs(enum) do
                    if app == filename then
                        findIt = true
                    end
                end
                assert(findIt, path..' : '..filename..' : '..tostring(enum))
            end

            local content = io.read(filename)
            if content then
                return assert(loadstring(assert(content), filename))
            end
        end
        errmsg = errmsg.."\n\tno file '"..filename.."' (checked with custom loader)"
    end
    return errmsg
end

function moduleExist(modulepath)
    local modulename
    if modulepath:find("%/%w+$") then 
        modulename = modulepath:sub(modulepath:find("%/%w+$")+1)
    else
        modulename = modulepath
    end

    local errmsg = ""
    for path in string.gmatch(love.filesystem.getRequirePath(), "([^;]+)") do
        local filename = string.gsub(path, "%?", modulepath)
        filename = string.gsub(filename, "%!", modulename)

        local info = love.filesystem.getInfo(filename)
        if info and info.type == 'file' then
            return true
        end
    end
    return false
end

-- This will run before the standard loader, if you want it to run after you can call table.insert(package.loaders, load)
table.insert(package.loaders, 2, moduleLoader)
