function setupWindow()
    X, Y, W, H = initWindow()
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
    else
        w, h = love2d.window.getMode()
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
