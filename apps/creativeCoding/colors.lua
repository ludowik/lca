function setup()
    win.position.x = db.get('x', 0)
    win.position.y = db.get('y', 0)

    clr = color.random()

    function go()        
        Tween(clr, color.random(), math.random(3), go)
    end

    go()
end

function draw()
    background(clr)
end

function touched(touch)
    if touch.state == PRESSED and touch.y < win.position.y + 25 then
        win.moving = true
    end

    if touch.state == MOVED and win.moving then
        win.position.x = win.position.x + touch.dx
        win.position.y = win.position.y + touch.dy
    end

    if touch.state == RELEASED then
        win.moving = false

        db.set('x', win.position.x)
        db.set('y', win.position.y)
    end
end
