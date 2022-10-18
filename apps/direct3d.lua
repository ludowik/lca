function setup()
    parameter.boolean('viewMode', true)
    
    if viewMode then   
        camera(0, 0, 1)
    end
end

function draw()
    background()

    if viewMode then 
        perspective()
    else
        ortho()

        translate(W/2, H/2)

        local alpha = atan(1/sqrt(2))
        local beta = PI/4

        rotate(alpha, 1, 0, 0)
        rotate(beta, 0, 1, 0)

        scale(3, 3, 3)
    end

    scale(2/W)
    strokeSize(2)
    stroke(colors.blue)
    
    line(-W, -H, W, H)
    line(-W, H, W, -H)

    noFill()
    rectMode(CENTER)
    rect(0, 0, 50, 50)
    
--    box()

    textMode(CENTER)
    text('Hello world!')
end
