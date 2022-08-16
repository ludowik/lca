

function setup()
    print("This example tracks multiple touches and colors them based on their ID")
    
    -- keep track of our touches in this table
    touches = {}
end

-- This function gets called whenever a touch
--  begins or changes state
function touched(touch)
    if touch.state == ENDED or touch.state == CANCELLED then
        -- When any touch ends, remove it from
        --  our table
        touches[touch.id] = nil
    else
        -- If the touch is in any other state 
        --  (such as BEGAN) we add it to our
        --  table
        touches[touch.id] = touch
    end
end

function draw()
    background(0, 0, 0, 255)
    
    for k,touch in pairs(touches) do

        -- Use the touch id as the random seed
        math.randomseed(touch.id)

        -- This ensures the same fill color is used for the same id
        fill(math.random(255),math.random(255),math.random(255))
        
        -- Draw ellipse at touch position
        ellipse(touch.pos.x, touch.pos.y, 100, 100)
    end
end
