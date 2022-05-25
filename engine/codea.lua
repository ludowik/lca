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
    local content = io.read(path..'/'..'Info.plist')

    if not content then assert(false, path) end

    -- loading dependencies
    local block = content:match('<key>Dependencies</key>.-<array>(.-)</array>')
    if block then
        for v in block:gfind('<string>(.-)</string>') do
            v = v:gsub('Documents:', '')

            print('load app codea '..v..'.dependencies')
            loadAppCodea('apps/codea-demo'..'/'..v, true)
        end
    end

    -- loading projects
    block = content:match('<key>Buffer Order</key>.-<array>(.-)</array>')
    if block then
        for v in block:gfind('<string>(.-)</string>') do
            if not isDependencies or v:lower() ~= 'main' then
                package.loaded[path..'/'..v] = nil
                require(path..'/'..v)
            end
        end
    end
end
