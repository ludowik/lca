
function setup()
    -- Tap this to bring up the sound picker
    sound(DATA, "ZgBAKgBLQFRAQEBAAAAAAK5T+j46fh4/UwBAf0BAQEBAZEBA")
    
    basicMenu = BasicMenu()
    advancedMenu = AdvancedMenu()
    
    menu = basicMenu
    menu:onEnter()
    
    button = Button("Go To Advanced")
    button.action = function () toggleMenu() end

end

function toggleMenu()
    if menu == basicMenu then
        menu = advancedMenu
        button.displayName = "Go To Basic"
    else
        menu = basicMenu
        button.displayName = "Go To Advanced"
    end
    
    menu:onEnter()
end

function drawButton()
    button.pos = vec2(WIDTH - button.size.x/2 - 20,HEIGHT/2)
    button:draw()
end

function draw()
    background(63, 63, 88, 255)
    
    menu:draw()
    
    drawButton()
end

function touched(touch)
    menu:touched(touch)
    button:touched(touch)
end

