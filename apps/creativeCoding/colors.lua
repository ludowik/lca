function setup()
    clr = color.random()

    function go()        
        Tween(clr, color.random(), math.random(3), go)
    end
    
    go()
end

function draw()
    background(clr)
end
