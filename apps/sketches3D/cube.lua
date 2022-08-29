function setup()
    camera(3,3,3)
end

function draw3d()    
    perspective()
    
    if elapsedTime/5 % 3 <= 1 then
        rotate(elapsedTime, 1, 0, 0)
    else
        rotate(elapsedTime, 0, 1, 0)
    end
    
    fill(colors.white)

    box(1)
    sphere(2.5)
end
