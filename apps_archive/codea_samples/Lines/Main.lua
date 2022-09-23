
function setup()
    -- Expose parameters to control our line

    -- The start point
    parameter.number("x1",0,WIDTH,100)
    parameter.number("y1",0,HEIGHT,100)

    -- The end point
    parameter.number("x2",0,WIDTH,WIDTH-100)
    parameter.number("y2",0,HEIGHT,HEIGHT-100)

    -- The stroke width
    parameter.number("width",1,100,10)
    
    -- The line cap type
    parameter.integer("lineCap",0,2,0)
end

function draw()
    background(10,10,20)

    -- Set stroke and fill color to white
    fill(255,0,0)
    stroke(255)

    -- Update stroke width
    strokeWidth(width)

    if width < 3 then
        -- Disable smoothing for low widths
        noSmooth()
    else
        smooth()
    end

    -- Set the line cap mode
    lineCapMode(lineCap)

    -- Draw the line
    line(x1,y1,x2,y2)
end

