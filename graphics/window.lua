function setupWindow(mode, scale)
    mode = mode or getMode()

    SCALE = scale or (env and env.SCALE) or 1

    X, Y, W, H = initWindow(mode)

    WIDTH, HEIGHT = W, H

    safeArea = {
        left = X,
        top = Y,
        right = X * 2 + W,
        bottom = Y * 2 + H
    }
end

local initModes = {}
function initModes.portrait()
    local x, y, w, h, wt, ht

    x = 160
    y = 24
    h = SCALE * 900
    w = h * 9/16

    wt = w / SCALE + x*3
    ht = h / SCALE + y*2

    return x, y, w, h, wt, ht
end

function initModes.landscape()
    local x, y, w, h, wt, ht

    x = 160
    y = 24
    w = SCALE * 900
    h = w * 9/16

    wt = w / SCALE + x*3
    ht = h / SCALE + y*2

    return x, y, w, h, wt, ht
end

function initModes.square()
    local x, y, w, h, wt, ht

    x = 160
    y = 24
    w = SCALE * 900
    h = w

    wt = w / SCALE + x*3
    ht = h / SCALE + y*2

    return x, y, w, h, wt, ht
end


function initWindow(mode)
    local x, y, w, h, wt, ht = 0, 0, 0, 0, 0, 0

    if os.name == 'web' then
        local w1, h1 = love.window.getDesktopDimensions()
        local w2, h2 = love.graphics.getDimensions()        
        if w1 < w2 then
            w, h = w1, h1
        else
            w, h = w2, h2
        end
        wt, ht = w, h

    elseif os.name == 'ios' then
        x, y = love.window.getSafeArea()
        wt, ht = love.window.getMode()
        w = wt - 2*x
        h = ht - 2*y

    else
        x, y, w, h, wt, ht = initModes[mode]()
    end

    w = round(w)
    h = round(h)

    if not global.__autotest then
        love.window.updateMode(
            wt,
            ht, {
                highdpi = false,

                usedpiscale = false,

                msaa = 8,
                depth = 24,
                vsync = 0,

                x = config.flags and config.flags.x or 100,
                y = config.flags and config.flags.y or 50,

                display = config.flags and config.flags.display or 1,
            })
    end

    return x, y, w, h
end

function setVSync(vsync)
    env.__vsync = vsync or 1
end
