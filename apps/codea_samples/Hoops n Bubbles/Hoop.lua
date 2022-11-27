Hoop = class()

function Hoop:init(x,y,col, helper)
    -- Each hoop is made out of 3 sections (two circles and a box). The collisions are filtered so that center does not collide with the poles allowing the hoops to hook over the top
    
    self.width = 30
    self.segments = 10
    
    self.left = physics.body(CIRCLE, 5)
    self.left.x = x - self.width/2
    self.left.y = y
    self.left.sleepingAllowed = false
    self.left.categories = {HOOP_EDGE}
    self.left.interpolate = true
    
    helper:addBody(self.left)
    
    self.right = physics.body(CIRCLE, 5)
    self.right.x = x + self.width/2
    self.right.y = y
    self.right.sleepingAllowed = false
    self.right.categories = {HOOP_EDGE}
    self.right.interpolate = true
    
    helper:addBody(self.right)
    
    self.middle = makeBox(x,y,self.width, 5)
    self.middle.sleepingAllowed = false
    self.middle.categories = {HOOP_MIDDLE}
    self.middle.interpolate = true
    
    helper:addBody(self.middle)
    
    -- Connect the 3 parts using some weld joints to make the whole object rigid
    self.joint1 = physics.joint(WELD, self.left, self.middle, vec2(x-self.width/2,y))
    self.joint2 = physics.joint(WELD, self.middle, self.right, vec2(x+self.width/2,y))
    
    -- Create a front and back image for the hoop so they can be rendered independantly
    self.frontImg = image(self.width * 1.5, self.width)
    setContext(self.frontImg)
    self:drawRing(col, 0.25)
    setContext()
    
    -- Make the back color slightly darker
    local col2 = color(col.r * 0.75, col.g * 0.75, col.b * 0.75)
    
    self.backImg = image(self.width * 1.5, self.width)
    setContext(self.backImg)
    self:drawRing(col2, -0.25)
    setContext()
    
end

-- Draws half a ring using some line segments
function Hoop:drawRing(col, bend)
    pushMatrix()
    translate(self.width * 0.75, self.width * 0.5)
    pushStyle()
    stroke(col)
    strokeWidth(5)
    lineCapMode(PROJECT)
    
    local delta = math.pi / self.segments
    for i = 1,self.segments do
        local angle1 = -delta * (i-1)
        local angle2 = -delta * i
        local p1 = vec2(math.cos(angle1), math.sin(angle1) * bend) * self.width * 0.5
        local p2 = vec2(math.cos(angle2), math.sin(angle2) * bend) * self.width * 0.5
        line(p1.x, p1.y, p2.x, p2.y)
    end
    
    popStyle()
    popMatrix()
end

function Hoop:drawBack()
    pushMatrix()
    translate(self.middle.x, self.middle.y)
    rotate(self.middle.angle)
    sprite(self.backImg,0,0)
    popMatrix()
end

function Hoop:draw()
    -- Increase damping based on velocity to simulate water drag
    self.left.linearDamping = self.left.linearVelocity:len() / 500
    self.right.linearDamping = self.right.linearVelocity:len() / 500
    
    pushMatrix()
    translate(self.middle.x, self.middle.y)
    rotate(self.middle.angle)
    sprite(self.frontImg,0,0)
    popMatrix()
end
