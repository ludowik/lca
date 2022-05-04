function draw()
    background()

    arrays = Buffer('vec2')

    local n = 1000
    arrays:alloc(n)

    for x=1,n do
        arrays[x].x = x
        arrays[x].y = H/2 + noise(x+time()) * 20 * random()
    end

    lines(arrays)
end
