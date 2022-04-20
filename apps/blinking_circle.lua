function draw()
    local nx = W / 6
    local ny = H / 6

    for i=0,nx do
        for j=0,ny do
            fill(Color(noise(ellapsedTime)))
            circle(
                (i + 0.5) * nx,
                (j + 0.5) * ny,
                noise((i+5)*(j+3), ellapsedTime/2) * nx / 4)
        end
    end
end
