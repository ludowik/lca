function setupWindow(mode, scale)
    mode = mode or getMode()
    SCALE = scale or 1
    
    X, Y, W, H = initWindow(mode)
    
    WIDTH, HEIGHT = W, H

    safeArea = {
        left = X,
        top = Y,
        right = X * 2 + W,
        bottom = Y * 2 + H
    }
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
        x = 250
        y = 24
        h = SCALE * 900
        w = h * 9/16
        
        wt = w / SCALE + x*3
        ht = h / SCALE + y*2
    end

    w = round(love.window.toPixels(w))
    h = round(love.window.toPixels(h))

    if mode == 'landscape' then
        w, h = h, w
        wt = w / SCALE + x*3
        ht = h / SCALE + y*2
        
    elseif w > h then
        w, h, wt, ht, x, y = h, w, ht, wt, y, x
    end

    local xpos, ypos = 100, 50 -- love.window.getPosition()

    love.window.updateMode(
        wt,
        ht, {
            highdpi = true,
            usedpiscale = true,
            msaa = 8,
            depth = 24,
            vsync = 0,
            x = xpos,
            y = ypos,
            display = 1,
        })
    
    return x, y, w, h
end

function setVSync(vsync)
    env.__vsync = vsync or 1
end
