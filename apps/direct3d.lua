function setup()
    parameter.boolean('viewMode', true)
end

function draw()
    background()
    
    if viewMode then 
        perspective()        
        camera(0, 0, 1500)
    else
--        ortho()
        translate(W/2, H/2)
    end

    line(-W, -H, W, H)
    line(-W, H, W, -H)
    
    rect(0, 0, 10, 10)
    
    text('pefpoazefjôajzef^ja^fj')
end
