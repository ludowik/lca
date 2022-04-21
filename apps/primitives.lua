function draw()
    background(colors.black)
    
--    function go(w, h)
--        seed(12)
--        translate(100, 100)
--        clip(100, 100, w, h)
--        for i=1,100 do
--            strokeSize(6)
--            stroke(Color.hsl(random()))
--            fill(Color.hsl(random(), random(), random()))
--            circle(random(w), random(h), random(w), random(h))
--        end
--    end

--    go(100, 100)

    strokeSize(5)

    local array = {}
    for i=1,100 do
        for j=1,100 do
            array[#array+1] = {
                    noise(i, ellapsedTime)*W,
                    noise(j, ellapsedTime)*H,
                    random(),
                    random(),
                    random(),
                }
        end
    end

    points(array)

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
