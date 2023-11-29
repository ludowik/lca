function setup()
    autotest()
end

function autotest()
    line1 = {vec2.randomInScreen(), vec2.randomInScreen()}
    line2 = {vec2.randomInScreen(), vec2.randomInScreen()}

    x, y = vec2.intersection(line1, line2)
end

function draw()
    background()

    stroke(colors.white)
    strokeSize(30)

    polyline(
        {
            line1[1].x,
            line1[1].y,
            x,
            y,
            line2[1].x,
            line2[1].y
        })

    stroke(colors.blue)
    strokeSize(1)

    line(line1[1].x, line1[1].y, line1[2].x, line1[2].y)
    line(line2[1].x, line2[1].y, line2[2].x, line2[2].y)

    stroke(colors.red)
    strokeSize(20)

    point(x, y)
end
