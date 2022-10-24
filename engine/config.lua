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

    if config.version == nil then
        config.version = '1.0'
        
        config.framework = 'love2d'
        config.renderer = 'love2d'

        config.show = table()
    end

    return config
end

function saveConfig()
    love.filesystem.write('_config.lua', 'return ' .. table.tolua(config))
end

config = loadConfig()

