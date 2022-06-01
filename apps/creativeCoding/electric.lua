function draw()
    background()

    local arrays = table()
    local size = 150
    
    for x=1,1000 do
        table.insert(arrays, x)
        table.insert(arrays, H/2 + random() * noise(elapsedTime + x / 10) * size)
    end

    polyline(arrays)
end
