function listProjectTabs()
    dir, name = config.appPath, config.appName

    local path = dir..'/'..name
    local content = love.filesystem.read(path..'/'..'Info.plist')

    if not content then assert(false, path) end

    local projectTabs = table()

    -- loading projects
    local block = content:match('<key>Buffer Order</key>.-<array>(.-)</array>')
    if block then
        for v in block:gfind('<string>(.-)</string>') do
            projectTabs:add(path..'/'..v)
        end
    end

    return projectTabs 
end

function readProjectTab(filePath)
    return (
        readText(filePath..'.lua') or
        readText(config.appPath..'/'..config.appName..'/'..filePath..'.lua')
    )
end