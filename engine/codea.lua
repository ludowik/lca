color = Color
image = Image

function sound()
end

function soundBufferSize()
    return 0, 0
end

font = fontName

physics = class 'Physics'

POLYGON = 'polygon'
DYNAMIC = 'dynamic'
STATIC = 'static'

Gravity = vec2()

function physics.gravity(g)
    physics.g = g or physics.g
end

function physics.resume()
end

function physics.body()
    return {
        x = 0,
        y = 0,
        angle = 0,
        points = {}
    }
end

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
