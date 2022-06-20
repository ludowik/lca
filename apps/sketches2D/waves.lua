function setup()
    sizeW = W
    sizeH = H

    buf1 = Buffer('float'):resize(sizeW*sizeH)
    buf2 = Buffer('float'):resize(sizeW*sizeH)

    damping = 0.95

    img = Image(sizeW, sizeH)
    img:background(colors.black)
end

function update(dt)
    for i=1,2 do
        step()
    end

    waterDrop(random(sizeW), random(sizeH))
end

function step()
    local index, offset, value, brigthness

    index = getOffset(2, 2-1)

    for y=2,sizeH-1 do        
        for x=2,sizeW-1 do
            value = (
                buf1[index-1] +
                buf1[index+1] +
                buf1[index-sizeW] +
                buf1[index+sizeW]
                ) * 0.5 - buf2[index]

            value = value * damping

            buf2[index] = value

            brigthness = 128 + value * 128

            offset = (index -1) * 4

            img:set(x, y, brigthness, brigthness, brigthness)

            index = index + 1
        end

        index = index + 2
    end

    buf1, buf2 = buf2, buf1
end

function getOffset(x, y)
    return round(x) + round(y) * sizeW
end

function draw()
    background(black)

    spriteMode(CORNER)
    sprite(img)

    noFill()

    rectMode(CORNER)
    rect(0, 0 , sizeW, sizeH)
end

function touched(touch)
    waterDrop(touch.x, touch.y)
end

function waterDrop(x, y, h)
    local offset = getOffset(x, y)
    buf1[offset] = h or random(100, 1000)
end
