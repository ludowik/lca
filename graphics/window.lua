function setupWindow(__mode, scale)
    local mode, square = getMode()

    SCALE = scale or (env and env.SCALE) or 1

    X, Y, W, H = initWindow(mode, square)

    WIDTH, HEIGHT = W, H

    safeArea = {
        left = X,
        top = Y,
        right = X * 2 + W,
        bottom = Y * 2 + H
    }
end

screenConfig = {
    W = 500,
    H = 500, -- * 9/16,
    X = 80,
    Y = 24,
    WP = 500
}

local initModes = {}

function initModes.portrait()
    local x, y, w, h, wt, ht

    x = screenConfig.X
    y = screenConfig.Y

    h = SCALE * screenConfig.W
    w = SCALE * screenConfig.H

    wt = w / SCALE + screenConfig.WP
    ht = h / SCALE + 2 * screenConfig.Y

    return x, y, w, h, wt, ht
end

function initModes.landscape(square)
    local x, y, w, h, wt, ht

    x = screenConfig.X
    y = screenConfig.Y

    if square then
        w = SCALE * screenConfig.H
        h = w
    else
        w = SCALE * screenConfig.W
        h = SCALE * screenConfig.H
    end
    
    w = SCALE * screenConfig.H
    h = w
    
    wt = w / SCALE + screenConfig.WP
    ht = h / SCALE + 2 * screenConfig.Y

    return x, y, w, h, wt, ht
end


function initWindow(mode, square)
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
        x, y, w, h = love.window.getSafeArea()
        x = x * 3
        w = w - x * 2
        wt, ht = love.window.getMode()
        wt, ht = min(wt, ht), max(wt, ht)

    else
        x, y, w, h, wt, ht = initModes[mode](square)
    end

    w = round(w)
    h = round(h)

    if not global.__autotest then
        if os.name == 'ios' then
            love.window.setMode(wt, ht)
        else
            love.window.updateMode(
                wt,
                ht, {
                    highdpi = not oswindows,
                    usedpiscale = not oswindows,

                    msaa = 1,
                    depth = 16,
                    vsync = 0,

                    x = config.flags and config.flags.x or 100,
                    y = config.flags and config.flags.y or 50,

                    display = config.flags and config.flags.display or 1,
                })
        end
    end

    return x, y, w, h
end

function setVSync(vsync)
    env.__vsync = vsync or 1
end
