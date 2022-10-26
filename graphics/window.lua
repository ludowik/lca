--[[
=> setupWindow
    => setupScreen
    => initWindow
        => initModes
        => love.window.setMode

=> supportedOrientations
    => setOrientation
        => updateMode
            => love.window.updateMode

]]

--debugStart()

local function setupScreen()
    local wt, ht
    local x

    if os.name == 'ios' then
        SCALE = 1 / 0.85

        wt, ht = love.graphics.getDimensions()
        x, y = love.window.getSafeArea()

    else        
        SCALE = 1 / 1

        wt = 812 / SCALE
        ht = 375 / SCALE

        x = 40
        y = 40
    end

    screenConfig = {
        WT = floor(wt),
        HT = floor(ht),

        W = floor(wt * (0.70)),
        H = floor(ht * (0.98)),

        X = x
    }

    screenConfig.Y = (screenConfig.HT - screenConfig.H) / 2

    screenConfig.WP = screenConfig.WT - screenConfig.X - screenConfig.W
end

local initModes = {}

local function initWindow(mode)
    mode = mode or LANDSCAPE
    local x, y, w, h, wt, ht = initModes[mode]()

    local display

    if os.name == 'ios' then
--        x, y, display = 0, 0, 0

    else
        x = config.flags and config.flags.x or 100
        y = config.flags and config.flags.y or 50

        display = 1 -- config.flags and config.flags.display or 1
    end

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

    return x, y, w, h
end

function setupWindow()
    setupScreen()

    local mode = getOrientation()

    X, Y, W, H = initWindow(mode)
    WIDTH, HEIGHT = W, H

    SCALE = SCALE or (env and env.SCALE) or 1    

    -- TODO : usefull
    safeArea = {
        left = X,
        top = Y,
        right = X * 2 + W,
        bottom = Y * 2 + H
    }
end

function initModes.portrait()
    local x, y, w, h, wt, ht

    x = screenConfig.Y
    y = screenConfig.X

    w = floor(SCALE * screenConfig.H)
    h = floor(SCALE * screenConfig.W)

    wt = screenConfig.HT
    ht = screenConfig.WT

    screenConfig.WP = screenConfig.HT - screenConfig.Y

    return x, y, w, h, wt, ht
end

function initModes.landscape()
    local x, y, w, h, wt, ht

    x = screenConfig.X
    y = screenConfig.Y

    w = floor(SCALE * screenConfig.W)
    h = floor(SCALE * screenConfig.H)

    wt = screenConfig.WT
    ht = screenConfig.HT

    screenConfig.WP = screenConfig.WT - screenConfig.X - screenConfig.W

    return x, y, w, h, wt, ht
end

local function updateMode(mode)
    mode = mode or LANDSCAPE
    local x, y, w, h, wt, ht = initModes[mode]()

    print('update mode '..wt..'x'..ht)
    love.window.updateMode(wt, ht)
end

PORTRAIT = 'portrait'

LANDSCAPE = 'landscape'
LANDSCAPE_ANY = 'landscape_any'

function supportedOrientations(orientations)
    if orientations == PORTRAIT then
        setOrientation(PORTRAIT)

    elseif orientations == LANDSCAPE_ANY or orientations == LANDSCAPE then
        setOrientation(LANDSCAPE)
    end
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
    local wt, ht = screenConfig.WT, screenConfig.HT -- love.graphics.getDimensions()

    newOrientation = newOrientation or orientation
    if newOrientation == LANDSCAPE then
        wt, ht = math.max(wt, ht), math.min(wt, ht)
    else
        wt, ht = math.min(wt, ht), math.max(wt, ht)
    end

    orientation = newOrientation

    updateMode(orientation)
end

function setVSync(vsync)
    env.__vsync = vsync or 1
end
