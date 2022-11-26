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

function db.clear(dbName)
    love.filesystem.remove(dbName..'.mydb')
end

function db.path(path)

    return path:replace('/', '.')
end

function db.load(dbName)
    local data = db.datas[dbName]
    if data == nil then
        local content = io.read(db.path(dbName..'.mydb'))
        if content then
            local code = loadstring('return '..content)
            if code then
                db.datas[dbName] = table(code())
            else
                db.datas[dbName] = table()
            end
        else
            db.datas[dbName] = table()
        end
        data = db.datas[dbName]
    end

    return data
end

function db.save(dbName, data)
    io.write(db.path(dbName..'.mydb'), table.tolua(data))
end

function readLocalData(key, defaultValue)
    return db.get('local.data', key, defaultValue)
end

function clearLocalData()
    db.clear('local.data')
end

function saveLocalData(key, value)
    return db.set('local.data', key, value)
end

function readProjectData(key, defaultValue)
    local path = _G.env.appName..'.data'
    return db.get(path, key, defaultValue)
end

function clearProjectData()
    local path = _G.env.appName..'.data'
    db.clear(path)
end

function saveProjectData(key, value)
    local path = _G.env.appName..'.data'
    return db.set(path, key, value)
end

function readGlobalData(key, defaultValue)
    return db.get('global.data', key, defaultValue)
end

function saveGlobalData(key, value)
    return db.set('global.data', key, value)
end

function clearGlobalData()
    db.clear('global.data')
end
