class 'db'

function db.setup()
    db.datas = table()
end

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
    local data = db.datas[dbName]
    if data == nil then
        local content = love.filesystem.read(dbName..'.mydb')
        if content then
            db.datas[dbName] = table(loadstring('return '..content)() )
        else
            db.datas[dbName] = table()
        end
        data = db.datas[dbName]
    end

    return data
end

function db.save(dbName, data)
    love.filesystem.write(dbName..'.mydb', data:tolua())
end
