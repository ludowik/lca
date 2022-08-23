function setup()
    setOrigin(BOTTOM_LEFT)
    db = Dashboard(classes.ref, {'__className', '__bases'})
end

function update(dt)
end

function wheelmoved(...)
    db:wheelmoved(...)
end

function draw()
    background()

    translate(200, 0)
    db:draw()
end
