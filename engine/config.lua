print(love.filesystem.getSaveDirectory())

function loadConfig()
    local name = 'config.lua'
    if love.filesystem.getInfo(name) then
        local ok, chunk, result
        ok, chunk = pcall(love.filesystem.load, name) -- load the chunk safely
        if ok then
            ok, result = pcall(chunk)
            if ok then
                return result
            end
        end
    end
    return {}
end

function saveConfig()
    love.filesystem.write('config.lua', 'return ' .. table.tolua(config))
end

config = loadConfig()
