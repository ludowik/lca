function setup()
    win.position.x = 100
    win.position.y = 100
end

function draw()
    background(51)
    
    textMode(CENTER)
    text('APPS', W/2, H/2)
end

function touched(touch)
    if touch.state == PRESSED then
        setActiveApp(loadApp('Apps', 'apps.the2048'))
    end
end
