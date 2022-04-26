function draw()
    background(colors.black)
    blendMode('add')
    
    noStroke()

    fill(colors.red)
    circle(W/3, H/2, W/6)
    
    fill(colors.green)
    circle(W/2, H/2, W/6)

    fill(colors.blue)
    circle(W*2/3, H/2, W/6)
end
