function draw()
    img = Image('res/images/breakout/brique.png')
    
    translate(W/2, H/2)
    rotate(elapsedTime)
    
    spriteMode(CENTER)
    sprite(img)
end
