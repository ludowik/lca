function setup()
    joconde = Image('res/images/joconde.png')
end

function update(dt)
end

function draw()
    tint(green)

    spriteMode(CENTER)
    sprite(joconde, W/2, H/2, 400, 400)

    stroke(red)
    strokeSize(2)

    noFill()

    circleMode(CENTER)
    circle(W/2, H/2, 100)

    ellipseMode(CENTER)
    ellipse(W/2, H/2, 100, 50)

    rectMode(CENTER)
    rect(W/2, H/2, 200, 200)

    fill(white)

    textMode(CENTER)
    text('HELLO', W/2, H/2)
end
