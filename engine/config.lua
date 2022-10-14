function loadConfig()
    local name = '_config.lua'
    
    local config = {}
    
    if love.filesystem.getInfo(name) then
        local ok, chunk = pcall(love.filesystem.load, name) -- load the chunk safely
        if ok then
            local ok, result = pcall(chunk)
            if ok and type(result) == 'table' then
                config = result
            end
        end
    end
    
    config.framework = config.framework or 'love2d'
    config.renderer = config.renderer or 'core'

    return config
end

function saveConfig()
    love.filesystem.write('_config.lua', 'return ' .. table.tolua(config))
end

config = loadConfig()

