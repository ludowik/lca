require 'engine.engine'

local angle, mode
function setup()
    angle = 0
    mode = 0
end

function update(dt)
    angle = angle + dt
end

function draw()
    local nx = 10
    local w = round(W / (nx + 2))
    local ny = round(H / w) - 2

    rectMode(CENTER)

    translate(w/2, w/2)


    strokeSize(0.1)
    stroke(colors.black)

    local f
    if mode == 0 then
        seed(2423525)
        f = random
    else
        f = function ()
            return cos(angle)
        end
    end

    for j=1,ny do
        translate(0, w)

        pushMatrix()
        for i=1,nx do
            translate(w, 0)

            pushMatrix()
            do
                fill(Color(1 - f() * (j/ny)))

                rotate((f() * 2 - 1 ) * PI * (j/(ny*2)))
                rect(0, 0, w*0.9, w*0.9)
            end
            popMatrix()
        end
        popMatrix()
    end
end

function mousepressed()
    mode = mode == 0 and 1 or 0
end
