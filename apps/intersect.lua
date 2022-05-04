function setup()
    line1 = {vec2.random(W,H), vec2.random(W,H)}
    line2 = {vec2.random(W,H), vec2.random(W,H)}
    
    x, y = vec2.intersection(line1, line2)
end

function draw()
    stroke(colors.gray)
    strokeSize(30)
        
    polyline(
        {
            line1[1].x,
            line1[1].y,
--            line1[2].x,
--            line1[2].y,
            x,
            y,
            line2[1].x,
            line2[1].y,
--            line2[2].x,
--            line2[2].y,
        })
    
    stroke(colors.blue)
    strokeSize(1)
    
    line(line1[1].x, line1[1].y, line1[2].x, line1[2].y)
    line(line2[1].x, line2[1].y, line2[2].x, line2[2].y)
    
    stroke(colors.green)
    strokeSize(5)
    
    point(x, y)
end
