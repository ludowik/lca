function loadConfig()
    local data = love.filesystem.read('config.lua')
    if data then
        data = 'local data = ' .. data .. ' return data'
        return pcall(load(data)()) or {}
    end
    return {}
end

function saveConfig()
    love.filesystem.write('config.lua', table.tolua(config))
end

config = loadConfig()
