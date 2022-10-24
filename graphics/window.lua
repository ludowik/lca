function setupWindow(mode, scale)
    mode = mode or getOrientation()

    SCALE = SCALE or scale or (env and env.SCALE) or 1

    X, Y, W, H = initWindow(mode)

    WIDTH, HEIGHT = W, H

    -- TODO : usefull
    safeArea = {
        left = X,
        top = Y,
        right = X * 2 + W,
        bottom = Y * 2 + H
    }
end

PORTRAIT = 'portrait'
LANDSCAPE = 'landscape'
LANDSCAPE_ANY = 'landscape_any'

function supportedOrientations(orientations)
    if orientations == PORTRAIT then
        setMode(PORTRAIT)

    elseif orientations == LANDSCAPE_ANY or orientations == LANDSCAPE then
        setMode(LANDSCAPE)
    end
end

local __mode, __square
-- TODO : simpifiable ?
function setMode(mode)
    env.__mode = mode or LANDSCAPE
--    if __mode == env.__mode then return end
    setupWindow(env.__mode)
    env.canvas = nil
    __mode = env.__mode
end

FULLSCREEN_NO_BUTTONS = 'FULLSCREEN_NO_BUTTONS'

function displayMode(mode)
    if mode == FULLSCREEN_NO_BUTTONS then
        love.window.setFullscreen(true)
    end
end

local orientation = LANDSCAPE

function getOrientation()
    return orientation
end

function setOrientation(newOrientation)
    local wt, ht = love.graphics.getDimensions()

    newOrientation = newOrientation or orientation
    if newOrientation == LANDSCAPE then
        wt, ht = math.max(wt, ht), math.min(wt, ht)
    else
        wt, ht = math.min(wt, ht), math.max(wt, ht)
    end

    orientation = newOrientation

    local w, h = love.window.getMode()
    if w ~= wt or h ~= ht then
        love.window.updateMode(wt, ht)
        print('update mode '..wt..'x'..ht)
    end
end

--debugStart()

do
    local wt, ht
    local x
    if os.name == 'ios' then
        SCALE = 1 / 0.75

        wt, ht = love.graphics.getDimensions()
        x, y = love.window.getSafeArea()

    else        
        SCALE = 1 / 1.25

        wt = 812 / SCALE
        ht = 375 / SCALE

        x, y = 40, 40
    end

    setOrientation(LANDSCAPE)

    screenConfig = {
        WT = floor(wt),
        HT = floor(ht),

        W = floor(wt * (0.75)),
        H = floor(ht * (0.98)),

        X = x
    }

    screenConfig.Y = (screenConfig.HT - screenConfig.H) / 2

    screenConfig.WP = screenConfig.WT - screenConfig.X - screenConfig.W
end

local initModes = {}

function initModes.portrait()
    local x, y, w, h, wt, ht

    x = screenConfig.Y
    y = screenConfig.X

    w = SCALE * screenConfig.H
    h = SCALE * screenConfig.W

    wt = screenConfig.HT
    ht = screenConfig.WT

    screenConfig.WP = screenConfig.HT - screenConfig.Y

    setOrientation(PORTRAIT)

    return x, y, w, h, wt, ht
end

function initModes.landscape()
    local x, y, w, h, wt, ht

    x = screenConfig.X
    y = screenConfig.Y

    w = SCALE * screenConfig.W
    h = SCALE * screenConfig.H

    wt = screenConfig.WT
    ht = screenConfig.HT

    screenConfig.WP = screenConfig.WT - screenConfig.X - screenConfig.W

    setOrientation(LANDSCAPE)

    return x, y, w, h, wt, ht
end

function initWindow(mode)
    local x, y, w, h, wt, ht = 0, 0, 0, 0, 0, 0

    x, y, w, h, wt, ht = initModes[mode]()

    w = round(w)
    h = round(h)

    if not global.__autotest then
        local x, y, display

        if os.name == 'ios' then
            --            x, y, display = 0, 0, 0

        else
            x = config.flags and config.flags.x or 100
            y = config.flags and config.flags.y or 50

            display = 1 -- config.flags and config.flags.display or 1
        end

        local w, h = love.window.getMode()
        if w ~= wt or h ~= ht or os.name == 'ios' then
            print('set mode '..wt..'x'..ht)

            love.window.setMode(
                wt,
                ht, {
                    highdpi = not oswindows,
                    usedpiscale = not oswindows,

                    msaa = 1,
                    depth = 16,
                    vsync = 0,

                    x = x,
                    y = y,

                    display = display,
                })
        end
    end

    return x, y, w, h
end

function setVSync(vsync)
    env.__vsync = vsync or 1
end
