-- Pencil Case

function setup()
    print("Apple Pencil Demo")
    print("- Finger touches will show in orange")    
    print("- Pencil touches will show in blue")        
end

function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here    
    local pos = CurrentTouch.pos
    local rad = 100
    
    if CurrentTouch.type == STYLUS then 
        fill(0, 114, 255, 255)
        pos = CurrentTouch.precisePos
        rad = 300 * (CurrentTouch.force / CurrentTouch.maxForce)
    else 
        fill(203, 76, 34, 255)
    end
    
    local alt = (math.pi / 2.0 - CurrentTouch.altitude) * 200
    local azi = CurrentTouch.azimuthVec * alt
    
    ellipse(pos.x, pos.y, rad)      
    
    line(pos.x, pos.y, pos.x + azi.x, pos.y + azi.y)
        
end

