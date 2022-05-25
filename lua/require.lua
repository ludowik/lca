function requireLib(...)
    local path = scriptPath(3)
    for i,v in pairs({...}) do
        require(path..'/'..v)
    end
end

function requirePlist(name)
    local plist = io.read(name)
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
