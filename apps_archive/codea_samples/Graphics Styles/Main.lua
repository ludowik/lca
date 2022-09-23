-- This example shows some of basic graphics functions you can use

function setup()
    print("The four shapes to the right show a number of graphical variations")
end

function draw()
    -- Note you can tap any color parameter to bring up the color picker
    background(104, 36, 130, 255)

    -- Set our basic red fill and white stroke
    fill(255,0,0)
    stroke(255)
    strokeWidth(10)

    -- Translate to center
    pushMatrix()
    translate(WIDTH*0.5,HEIGHT*0.5)

    -- Draw one circle
    ellipse(-100, 100, 190, 190)
    
    -- Draw one circle, push new style
    pushStyle()
    fill(209, 152, 230, 255)
    noStroke()
    ellipse(100, 100, 190, 190)

    -- Draw one circle, push another style
    pushStyle()
    fill(217, 107, 203, 255)
    stroke(242, 197, 233, 255)
    strokeWidth(5)
    ellipse(-100, -100, 190, 190)

    -- Draw one circle, pop both styles
    -- this will use the first style
    popStyle()
    popStyle()
    ellipse(100, -100, 190, 190)

    popMatrix()
end

