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

local setupScreen, initWindow
function setupWindow()
    setupScreen()

    local mode = getOrientation()

    X, Y, W, H = initWindow(mode)
    WIDTH, HEIGHT = W, H

    SCALE_APP = (env and env.SCALE_APP) or screenConfig.SCALE_APP

    -- TODO : usefull
    safeArea = {
        left = X,
        top = Y,
        right = X * 2 + W,
        bottom = Y * 2 + H
    }
end

setupScreen = function()
    local wt, ht, scale
    local x

    if os.name == 'ios' then
        scale = 1.25

        wt, ht = love.graphics.getDimensions()
        x, y = love.window.getSafeArea()

    else        
        SCALE_SCREEN = 1
        scale = 0.85

        wt = 812
        ht = 375

        x = 40
        y = 40
    end

    screenConfig = {
        WT = floor(wt),
        HT = floor(ht),

        W = floor(wt * (0.70)),
        H = floor(ht * (0.98)),
        
        SCALE_APP = scale,

        X = x,
    }

    screenConfig.Y = (screenConfig.HT - screenConfig.H) / 2

    screenConfig.WP = screenConfig.WT - screenConfig.X - screenConfig.W
end

local initModes = {}

initWindow = function (mode)
    mode = mode or LANDSCAPE
    local left, top, w, h, wt, ht = initModes[mode]()

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

    return left, top, w, h
end

function initModes.portrait()
    local x, y, w, h, wt, ht

    x = screenConfig.Y
    y = screenConfig.X

    w = floor(screenConfig.SCALE_APP * screenConfig.H)
    h = floor(screenConfig.SCALE_APP * screenConfig.W)
    
    w = w + w % 2
    h = h + h % 2

    wt = screenConfig.HT
    ht = screenConfig.WT

    screenConfig.WP = screenConfig.HT - screenConfig.Y

    return x, y, w, h, wt, ht
end

function initModes.landscape()
    local x, y, w, h, wt, ht

    x = screenConfig.X
    y = screenConfig.Y

    w = floor(screenConfig.SCALE_APP * screenConfig.W)
    h = floor(screenConfig.SCALE_APP * screenConfig.H)
    
    w = w + w % 2
    h = h + h % 2

    wt = screenConfig.WT
    ht = screenConfig.HT

    screenConfig.WP = screenConfig.WT - screenConfig.X - screenConfig.W

    return x, y, w, h, wt, ht
end

local function updateMode(mode)
    mode = mode or LANDSCAPE
    local x, y, w, h, wt, ht = initModes[mode]()

    local _wt, _ht = love.window.getMode()
    if _wt ~= wt then
        print('update mode '..wt..'x'..ht)
        love.window.updateMode(wt, ht)
    end

    return x, y, w, h, wt, ht
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
    return env and env.__orientation or orientation
end

function setOrientation(newOrientation)
    local wt, ht = screenConfig.WT, screenConfig.HT -- love.graphics.getDimensions()

    newOrientation = newOrientation or getOrientation()
    if newOrientation == LANDSCAPE then
        wt, ht = math.max(wt, ht), math.min(wt, ht)
    else
        wt, ht = math.min(wt, ht), math.max(wt, ht)
    end

    orientation = newOrientation
    if env then
        env.__orientation = orientation
    end

    X, Y, W, H = updateMode(orientation)
    WIDTH, HEIGHT = W, H
end

function setVSync(vsync)
    env.__vsync = vsync or 1
end
