function draw()
    img = Image()
    
    translate(W/2, H/2)
    rotate(elapsedTime)
    
    spriteMode(CENTER)
    sprite(img)
end
