function loadConfig()
    local name = 'config.lua'
    if core.filesystem.getInfo(name) then
        local ok, chunk, result
        ok, chunk = pcall(core.filesystem.load, name) -- load the chunk safely
        if ok then
            ok, result = pcall(chunk)
            if ok and type(result) == 'table' then
                return result
            end
        end
    end
    return {}
end

function saveConfig()
    core.filesystem.write('config.lua', 'return ' .. table.tolua(config))
end

config = loadConfig()
