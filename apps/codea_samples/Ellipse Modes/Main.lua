--This is an example of the ellipseMode. 
--It is an integer value from 0 to 3.
--The ellipse modes are:
--      0 = CORNER (x,y = bottom left of bounding rectangle)
--      1 = CORNERS (x,y = bottom left as above, 
--                   and w,h is now the top right corner absolute
--                   position, not the width and height)
--      2 = CENTER ( x,y = the center of the ellipse, 
--                   w,h is the width and height)
--      3 = RADIUS ( x,y = the center of the ellipse, 
--                   w,h are the horizontal and vertical
--                   radii. Its basically the same as CENTER, 
--                   but w and h are doubled)

function setup()
    viewer.mode = OVERLAY
    
    parameter.integer("EllipseMode",0,3)
    parameter.number("x",0,200.0)
    parameter.number("y",0,200,0)
    parameter.number("w",0,WIDTH,150)
    parameter.number("h",0,HEIGHT,150)

    --The rect methods do pretty much the same as the ellipse ones, but
    --they draw a rectangle with x,y,w,h. Setting this to true shows that.
    parameter.boolean("DrawRect")
end

function draw()
    background(10,10,20)
    fill(255,0,0)
    stroke(255)
    strokeWidth(20)
    
    translate(WIDTH/2,HEIGHT/2)
    
    if DrawRect == true then
        rectMode(EllipseMode)
        rect(x,y,w,h)	    
    else
        ellipseMode(EllipseMode)
        ellipse(x,y,w,h)
    end
end

