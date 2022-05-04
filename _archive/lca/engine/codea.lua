viewer = {
    close = love.event.quit
}

layout = {
    safeArea = {
        left = 0,
        right = 0,
        top = 32,
        bottom = 32
    }
}

asset = table{
    documents_list = table{},
    documents = table{
        ['the2048'] = {},

        ['morpion'] = {},

        ['cargo-bot'] = {},

        ['Ide'] = {
            Path = '../codea/ide.codea',
            Main = '../codea/ide.codea/Main.lua'
        },
        ['Cells'] = {
            Path = '../codea/cells.codea',
            Main = '../codea/cells.codea/Main.lua'
        },
    }
}

function getApps(path)
    local enum = love.filesystem.getDirectoryItems('apps/'..path)
    for i,app in ipairs(enum) do
        asset.documents[path..'/'..app:gsub('.lua', '')] = {}
    end
end
getApps('creativeCoding')

function getCodeaApps(path)
    local enum = love.filesystem.getDirectoryItems('apps/'..path)
    for i,app in ipairs(enum) do
        asset.documents[path..'/'..app:gsub('.lua', '')..''] = {}
    end
end
getCodeaApps('codea')

for k,v in pairs(asset.documents) do
    asset.documents_list:add({k=k,v=v})
end

vector = vec2
