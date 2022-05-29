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
    local x, y, w, h, wt, ht = 0, 0, 0, 0, 0, 0

    if os.name == 'web' then
        local w1, h1 = love2d.window.getDesktopDimensions()
        local w2, h2 = love2d.graphics.getDimensions()        
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
        x = 150
        y = 24
        h = 900
        w = h * 9/16
        wt, ht = w+x*2, h+y*2
    end

    w = round(love2d.window.toPixels(w))
    h = round(love2d.window.toPixels(h))

    if w > h then
        w, h, wt, ht, x, y = h, w, ht, wt, y, x
    end

    love2d.window.setMode(
        wt,
        ht, {
            highdpi = true,
            usedpiscale = true,
            msaa = 8,
            depth = 24,
            vsync = 0
        })

    return x, y, w, h
end
