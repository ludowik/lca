--[[
=> setupWindow
    => setupScreen
    => initWindow
        => initModes
        => love.window.setMode

=> supportedOrientations
    => setOrientation
        => setupScreen
        => updateMode
            => love.window.updateMode
]]

local setupScreen, initWindow
function setupWindow()
    setupScreen()

    _G.SCALE_APP = (env and env.SCALE_APP) or screenConfig.SCALE_APP or 1

    X, Y, W, H = initWindow(getOrientation())
    WIDTH, HEIGHT = W, H
end

local ios_w, ios_h = 692, 320
simulate_ios = simulate_ios or false

setupScreen = function()
    local wt, ht, scale
    local x, y

    if os.name == 'ios' then
        SCALE_APP = 1.25

        wt, ht = love.graphics.getDimensions()
        x, y, w, h = love.window.getSafeArea()

        if wt > ht then
            y = floor((ht - h)/2)
        else
            wt, ht = ht, wt
            x, y, w, h = x, y, h, w
        end

    else
        scale = 1.25

        if getOrientation() == LANDSCAPE then
            wt = simulate_ios and ios_w or os.name == 'osx' and 1280 or 1280 
        else
            wt = simulate_ios and ios_w or os.name == 'osx' and  896 or 896
        end

        local ratio = 1 / 1.8
        ht = floor(wt * ratio) + floor(wt * ratio) % 2

        x, y = 38, 24
        w, h = wt-2*x, ht-2*y

    end

    WMAX = 250 -- max(w, h) / 4

    screenConfig = {
        WT = floor(wt),
        HT = floor(ht),

        W = floor(w),
        H = floor(h),

        SCALE_APP = SCALE_APP,

        X = x,
        Y = y,
    }
end

function getSafeArea()
    return screenConfig.X, screenConfig.Y, screenConfig.W, screenConfig.H
end

local initModes = {}

initWindow = function (mode)
    mode = mode or LANDSCAPE
    local left, top, w, h, wt, ht = initModes[mode]()

    local x, y, display
    if os.name == 'ios' then
--        x, y, display = 0, 0, 0

    else
        x = config.flags and config.flags.x or 100
        y = config.flags and config.flags.y or 50

        display = 1 -- config.flags and config.flags.display or 1
    end

    log('set mode', wt, ht)

    love.window.setMode(wt, ht,
        {
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

    w = floor(SCALE_APP * screenConfig.H)
    h = floor(SCALE_APP * screenConfig.W)

    w = w + w % 2
    h = h + h % 2

    wt = screenConfig.HT
    ht = screenConfig.WT

    return x, y, w, h, wt, ht
end

function initModes.landscape()
    local x, y, w, h, wt, ht

    x = screenConfig.X
    y = screenConfig.Y

    w = floor(SCALE_APP * screenConfig.W)
    h = floor(SCALE_APP * screenConfig.H)

    w = w + w % 2
    h = h + h % 2

    wt = screenConfig.WT
    ht = screenConfig.HT

    return x, y, w, h, wt, ht
end

local __orientation = LANDSCAPE

local function updateMode(mode)
    mode = mode or LANDSCAPE
    local left, top, w, h, wt, ht = initModes[mode]()

    local _wt, _ht = love.window.getMode()
    if _wt ~= wt and not env.__autotest then
        local x, y, display
        if os.name == 'ios' then
--        x, y, display = 0, 0, 0

        else
            x = config.flags and config.flags.x or 100
            y = config.flags and config.flags.y or 50

            display = 1 -- config.flags and config.flags.display or 1
        end

        log('update mode', wt, ht, _wt, _ht)

        love.window.updateMode(wt, ht,
            {
                x = x,
                y = y,

                display = display,
            })
    end

    _wt, _ht = love.window.getMode()
    wt, ht = _wt, _ht
    if wt < ht then
        w, h = min(w, h), max(w, h)
        left, top = min(left, top), max(left, top)
        __setOrientation(PORTRAIT)
    else
        w, h = max(w, h), min(w, h)
        left, top = max(left, top), min(left, top)
        __setOrientation(LANDSCAPE)
    end

    return left, top, w, h, wt, ht
end

PORTRAIT = 'portrait'

LANDSCAPE = 'landscape'
LANDSCAPE_ANY = 'landscape_any'

function supportedOrientations(orientations)
    if orientations == PORTRAIT then
        setOrientation(PORTRAIT)
        if env then
            env.__orientation = PORTRAIT
        end

    elseif orientations == LANDSCAPE_ANY or orientations == LANDSCAPE then
        setOrientation(LANDSCAPE)
        if env then
            env.__orientation = LANDSCAPE
        end
    end
end

FULLSCREEN_NO_BUTTONS = 'FULLSCREEN_NO_BUTTONS'

function displayMode(mode)
    if mode == FULLSCREEN_NO_BUTTONS then
        love.window.setFullscreen(true)
    end
end

function getOrientation()
    return env and env.__orientation or __orientation
end

function __setOrientation(newOrientation)
    assert(newOrientation)
    __orientation = newOrientation
end

function setOrientation(newOrientation)
    newOrientation = newOrientation or getOrientation() or LANDSCAPE
    __setOrientation(newOrientation)
    setupScreen()

    X, Y, W, H = updateMode(__orientation)
    WIDTH, HEIGHT = W, H
end

function setVSync(vsync)
    env.__vsync = vsync or 1
end
