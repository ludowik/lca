function setup()
    throws = 0
    inCircle = 0

    parameter.watch('4 * inCircle / throws')
    parameter.watch('inCircle.."/"..throws')

    seed(time())

    noFill()

    stroke(white)
    strokeSize(2)

    translate(W/2, H/2)

    radius = min(W, H) / 3
    diameter = radius * 2

    circle(0, 0, radius)

    fill(red)

    img = Image(diameter+1, diameter+1)

    clr = Color.random():alpha(.2)
end

function update(dt)
    if random() < 0.05 then
        clr = Color.random()
    end

    local sqrt, random, floor = math.sqrt, math.random, math.floor

    local rx, ry, x, y, len

    for i=1,10^5 do

        rx = random()
        ry = random()

        len = (
            (rx*2-1)^2 +
            (ry*2-1)^2)

        throws = throws + 1
        
        x = floor(rx*diameter)
        y = floor(ry*diameter)

        if len <= 1 then
            inCircle = inCircle + 1
            img:set(x, y, clr)
        else
            img:set(x, y, colors.blue)
        end
    end    
end

function draw()
    blendMode(NORMAL)

    translate(W/2, H/2)

    spriteMode(CENTER)
    sprite(img, 0, 0)
end
