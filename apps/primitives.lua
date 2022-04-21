function draw()
    
    seed(12)
    translate(100, 100)
    local w, h = 50, 50
    love.graphics.setScissor(100, 100, 50, 50)
    for i=1,100 do
        strokeSize(6)
        stroke(Color.hsl(random()))
        point(random(w), random(h))
    end
    
--    textMode(CENTER)
--    text('hello world', W/2, H/2)
    
--    strokeSize(5)
--    stroke(colors.blue)
    
--    line(50, 50, 100, 120)
--    line(250, 25, 150, 200)
    
--    translate(0, 100)
--    lines({50, 50, 100, 100, 250, 25, 150, 200})
    
--    translate(0, 100)
--    polyline({50, 50, 100, 100, 250, 25, 150, 200})
    
--    translate(0, 100)
--    polygon({50, 50, 100, 100, 250, 25, 150, 200})
end
