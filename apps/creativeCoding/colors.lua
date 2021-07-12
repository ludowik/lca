function setup()
    clr = color.random()

    function go(tween)        
        if tween then tween:remove() end
        Tween(clr, color.random(), math.random(3), go)
    end

    go(nil)
end

function draw()
    background(clr)
end
