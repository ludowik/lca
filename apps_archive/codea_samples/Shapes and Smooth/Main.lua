-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    parameter.boolean("SMOOTH")
    parameter.boolean("STROKE")
    parameter.boolean("SHAPE")
end

-- This function gets called once every frame
function draw()
    background(0)    

    if SMOOTH == false then
        noSmooth()
    else
        smooth()
    end
    
    if STROKE == false then
        noStroke()
    else
        strokeWidth(10)
        stroke(255)
    end
    
    fill(255, 0, 0, 255)
    
    translate(WIDTH/2,HEIGHT/2)
    rotate(ElapsedTime)
    
    if SHAPE == false then
        rectMode(CENTER)
        rect(0,0,300,300)
    else
        ellipse(0,0,300,300)
    end
end

