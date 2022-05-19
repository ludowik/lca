function draw()
    background()

    arrays = table()

    for x=1,1000 do
        table.insert(arrays, x)
        table.insert(arrays, H/2 + noise(x+time()) * 20 * random())
    end

    polyline(arrays)
end
