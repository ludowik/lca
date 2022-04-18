function setupWindow()
    local x, y, h, w = love.window.getSafeArea()
    w = love.window.toPixels(w)
    h = love.window.toPixels(h)

    love.window.setMode(w, h, {
            highdpi = true,
            usedpiscale = true,
        })

    windowSize = string.format('Size %d, %d', w, h)

    local major, minor, revision, codename = love.getVersion()
    version = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)

    W, H = love.graphics.getDimensions()
end

