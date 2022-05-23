function setupWindow()
    X, Y, W, H = initWindow()
    WIDTH, HEIGHT = W, H

    safeArea = {
        left = X,
        top = Y,
        right = X * 2 + W,
        bottom = Y * 2 + H
    }
end

local love2d = love
function initWindow()
    local w, h
    if os.name == 'web' then
        local w1, h1 = love2d.window.getDesktopDimensions()
        local w2, h2 = love2d.graphics.getDimensions()        
        if w1 < w2 then
            w, h = w1, h1
        else
            w, h = w2, h2
        end

    elseif os.name == 'osx' then
        w = 1024
        h = w -- * 9/16

    else -- if os.name == 'windows' then
        w = 900
        h = w * 9/16
    end

    w = love2d.window.toPixels(w)
    h = love2d.window.toPixels(h)

    w, h = min(w,h), max(w,h)

    love2d.window.setMode(w, h, {
            highdpi = true,
            usedpiscale = true,
            msaa = 8,
            depth = 24,
        })

    return getSafeArea()
end
