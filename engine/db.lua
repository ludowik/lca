class 'db'

function db.set(dbName, key, value)
    local data = db.load(dbName)
    data[key] = value
    db.save(dbName, data)
end

function db.get(dbName, key, default)
    local data = db.load(dbName)
    if data[key] ~= nil then
        return data[key]
    end
    return default
end

function db.load(dbName)
    if db.data == nil then
        local content = love.filesystem.read(dbName..'.mydb')
        if content then
            db.data = table(loadstring('return '..content)() )
        else
            db.data = table()
        end
    end
    
    return db.data
end

function db.save(dbName, data)
    love.filesystem.write(dbName..'.mydb', data:tolua())
end
