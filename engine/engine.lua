nilf = function() end 

setup = setup or nilf
update = update or nilf
draw = draw or nilf

function makelove()
    if love.system.getOS() ~= 'OS X' then return end
    os.execute('makelove')
    os.execute('unzip -o makelove-build/lovejs/lca-lovejs.zip')
--    os.execute('python3 -m http.server 8080 --directory lca')
end

function love.load()
    makelove()
    
    local x, y, h, w = love.window.getSafeArea()
    w = love.window.toPixels(w)
    h = love.window.toPixels(h)

    love.window.setMode(w, h)
    
    windowSize = string.format('Size %d, %d', w, h)
    
    local major, minor, revision, codename = love.getVersion()
    version = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)

    W, H = love.graphics.getDimensions()
    setup()
end

function love.update(dt)
    update(dt)
end

function love.draw()
    resetMatrix()
    resetStyles()
    
    draw()
    
    resetMatrix()
    
    love.graphics.print(love.timer.getFPS(), 0, 0)
    
    love.graphics.print(windowSize, 0, 20)
end

function love.keyreleased(key)
    if key == 'escape' then love.event.quit() end
end
