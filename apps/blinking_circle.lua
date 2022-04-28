function draw()
    blendMode('alpha')
    
    background(Color(0, 0, 0, 0.05))
    
    circleMode(CENTER)
    
    layer(1, 1, 0.05)
    layer(7, 7, 0.1)
    layer(22, 22, 0.05)
end

function layer(nx, ny, alpha)
    ny = ny or nx
    
    local w = W / nx
    local h = H / ny
    
    noStroke()
    
    for i=1,nx do
        for j=1,ny do
            local val = noise((i+5)*(j+3), elapsedTime/2)
            fill(Color.hsl(val, 0.5, 0.5, alpha))
            circle(
                (i - 0.5) * w,
                (j - 0.5) * h,
                val * w / 2)
        end
    end
end
