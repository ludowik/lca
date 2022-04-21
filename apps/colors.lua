function draw()    
--    fill(colors.red)
    fill(Color.hsl2rgb(2/3,.5,.5))
    noFill()
    circle(W/3, H/2, W/6)
    
--    fill(colors.yellow)
    fill(Color.hsb2rgb(2/3,.5,1))
    circle(W/2, H/2, W/6)
    
    fill(colors.blue)
    circle(W*2/3, H/2, W/6)
end
