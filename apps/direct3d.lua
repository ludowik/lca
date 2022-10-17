function setup()
    parameter.boolean('viewMode', true)
end

function draw()
    background()

    if viewMode then 
--        perspective()        
--        camera(0, 0, 1500)
        isometric(3)
    else
        ortho()

        translate(W/2, H/2)

        local alpha = atan(1/sqrt(2))
        local beta = PI/4

        rotate(alpha, 1, 0, 0)
        rotate(beta, 0, 1, 0)

        scale(3, 3, 3)
    end

    line(-W, -H, W, H)
    line(-W, H, W, -H)

    noFill()
    rectMode(CENTER)
    rect(0, 0, 100, 100)

    text('pefpoazefjôajzef^ja^fj')
end
