class 'db'

function db.set(key, value)
    local data = db.load()
    data[key] = value
    db.save(data)
end

function db.get(key, default)
    local data = db.load()
    if data[key] ~= nil then
        return data[key]
    end
    return default
end

function db.load()
    if db.data == nil then
        local content = love.filesystem.read('db')
        db.data = table(loadstring('return '..content)() )
    end
    
    return db.data
end

function db.save(data)
    love.filesystem.write('db', data:tolua())
end
