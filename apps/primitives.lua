function draw()
    background(colors.black)

    local function drawPrimitive(prim, x, y, w, h)
        assert(x and y and w)
        h = h or w

        seed(12)

        clip(x, y, w, h)

        pushMatrix()
        do
            translate(x, y)

            local function callPrimitive(...)
                strokeSize(random(1, 5))
                stroke(Color.hsl(random()))
                
                textColor(Color.hsl(random()))
                fontSize(random(8, 24))

                fill(Color.hsl(random(), random(), random()))

                prim.f(...)
            end            

            local n = 10

            if prim.type and prim.type == 'table' then
                local t = {}
                for i=1,n do
                    table.insert(t, {
                            random(w),
                            random(h),
                            random(w),
                            random(h)
                        })
                end

                callPrimitive(t)
            else            
                for i=1,n do
                    callPrimitive(
                        random(w),
                        random(h),
                        random(w),
                        random(h),
                        random(w),
                        random(h),
                        random(w),
                        random(h))
                end
            end
        end
        popMatrix()
    end

    local marge = 10
    local x, y = marge, marge

    local n = 3
    local size = (W - (n+1) * marge) / n

    local primitives = {
        {f = point, },
        {f = points, type = 'table'},
        {f = line},
        {f = lines},
        {f = polyline},
        {f = rect},
        {f = circle},
        {f = ellipse},
        {f = function (x, y)
                textMode(CENTER)
                pushMatrix()
                do
                    translate(x, y)
                    rotate(random() * TAU)
                    text('hello', 0, 0)
                end
                popMatrix()
            end },
    }

    for _,prim in ipairs(primitives) do
        if x + size >= W then
            x = marge
            y = y + size + marge
        end
        drawPrimitive(prim, x, y, size)
        x = x + size + marge
    end
end
