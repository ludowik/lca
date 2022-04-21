function draw()
    layer(2)
    layer(8)
    layer(32)
end

function layer(nx, ny)
    ny = ny or nx
    
    local w = W / nx
    local h = H / ny
    
    for i=1,nx do
        for j=1,ny do
            local val = noise((i+5)*(j+3), ellapsedTime/2)
            fill(Color.hsl2rgb(val))
            circle(
                (i - 0.5) * w,
                (j - 0.5) * h,
                val * w / 4)
        end
    end
end
