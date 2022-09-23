viewer.mode = FULLSCREEN
hideKeyboard()

function setup()
    touches = Touches()
    
    local fontScale = 1.0
    
    print(layout.horizontal)
    if layout.horizontal == layout.COMPACT then
        fontScale = 0.6
        
        print("Compact")
    end
    
    mfont = Font({name = "Futura-Medium",size = 256 * fontScale})
    lfont = Font({name = "Futura-Medium",size = 24 * fontScale})
    anagram = Anagram(mfont,lfont,touches)
end

-- This function gets called once every frame
function draw()
    -- process touches and taps
    touches:draw()
    background(0,0,0)
    
    pushStyle()
    fill(255)
    textMode(CORNER)
    text("Drag letters to form words!", 20, HEIGHT - 50 - layout.safeArea.top)
    popStyle()
    
    -- draw elements
    anagram:draw(WIDTH/2,HEIGHT/2)
end

function touched(touch)
    touches:addTouch(touch:clone())
end


