function setupWindow()
    local w, h
    if os.name == 'web' then
        local w1, h1 = love.window.getDesktopDimensions()
        local w2, h2 = love.graphics.getDimensions()        
        if w1 < w2 then
            w, h = w1, h1
        else
            w, h = w2, h2
        end
    else
        w, h = love.window.getMode()
    end
    
    w = love.window.toPixels(w)
    h = love.window.toPixels(h)
    
    w, h = min(w,h), max(w,h)

    love.window.setMode(w, h, {
            highdpi = true,
            usedpiscale = true,
        })

    windowSize = string.format('Size %d, %d', w, h)

    local major, minor, revision, codename = love.getVersion()
    version = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)

    W, H = love.graphics.getDimensions()
end

