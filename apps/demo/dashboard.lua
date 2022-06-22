function setup()
    db = Dashboard(__classes, {'__className', '__bases'})
end

function update(dt)
end

function mouseWheel(mouse)
    db:mouseWheel(mouse)
end

function draw()
    background()

    translate(200, 0)
    db:draw()
end
