Button = class()

function Button:init(x,y,r,action)
    self.x = x
    self.y = y
    self.r = r
    self.action = action
    self.pressed = false
end

function Button:draw()
    pushMatrix()
    translate(self.x, self.y)
    pushStyle()
    
    noStroke()
    fill(202, 170, 164, 255)
    ellipseMode(CENTER)
    ellipse(0,0, self.r)
    fill(94, 36, 36, 255)
    ellipse(0,0,self.r * 0.8)
    fill(255, 0, 0, 255)
    
    -- Adjust button appearance when being pressed
    if self.pressed then
        ellipse(0,0,self.r * 0.8)
    else
        ellipse(0,self.r*0.05,self.r * 0.8)
    end
    popStyle()
    popMatrix()
end

-- Check if a point is inside the button
function Button:hitTest(x,y)
    return vec2(self.x, self.y):dist(vec2(x,y)) < self.r
end

function Button:touched(touch)
    if touch.state == BEGAN or touch.state == MOVING then
        -- Update button state based on when the touch is inside it
        self.pressed = self:hitTest(touch.x, touch.y)
    elseif touch.state == ENDED then
        self.pressed = false
        -- If touch is inside the button when ended perform button action
        if self:hitTest(touch.x, touch.y) then
            self.action()
        end
    end
end