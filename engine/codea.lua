color = Color
image = Image

font = fontName

local __class = class
class = function (...)
    local k = __class('Codea'..id())
    for _,base in ipairs({...}) do
        k:extends(base)
    end
    return k
end

function loadAppCodea(path, isDependencies)
    if isDependencies then
        print('load dependencies codea '..path..'/'..'Info.plist')
    else
        print('load app codea '..path..'/'..'Info.plist')
    end 
    
    local content = love.filesystem.read(path..'/'..'Info.plist')

    if not content then assert(false, path) end

    -- loading dependencies
    local block = content:match('<key>Dependencies</key>.-<array>(.-)</array>')
    if block then
        for v in block:gfind('<string>(.-)</string>') do
            v = v:gsub('Documents:', '')
            loadAppCodea('apps/codea_demo'..'/'..v, true)
        end
    end

    -- loading projects
    block = content:match('<key>Buffer Order</key>.-<array>(.-)</array>')
    if block then
        for v in block:gfind('<string>(.-)</string>') do
            if not isDependencies or v:lower() ~= 'main' then
                package.loaded[path..'/'..v] = nil
                print('load file '..v)
                require(path..'/'..v)
            end
        end
    end
end
