BubbleJet = class()

function BubbleJet:init(x,y,w,h, force)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.force = force
    
    self.bubbles = Bubbles(x, y - h/2)
end

function BubbleJet:draw()
    if drawPhysicsDebug then
        pushStyle()
        noFill()
        stroke(250, 0, 255, 255)
        strokeWidth(3)
        rectMode(CENTER)
        rect(self.x, self.y, self.w, self.h)
        popStyle()
    end
    
    self.bubbles:update()
    self.bubbles:draw()
end

function BubbleJet:addBubble(x,y,size,life)
    local bubble = {x = x, y = y, size = size, life = life}
    table.insert(self.bubbles, bubble)
end

function BubbleJet:activate()
    sound(SOUND_POWERUP, 19094, 0.25)
    
    -- Find all the physics objects inside the bubble jet rectangle
    local results = physics.queryAABB(vec2(self.x-self.w/2, self.y-self.h/2),
    vec2(self.x+self.w/2, self.y+self.h/2))
    
    -- Apply upward force to objects
    local mid = self.x + self.w / 2
    for k,v in pairs(results) do
        local diff = v.x - mid
        v:applyForce(vec2(diff * 0.1,self.force))
    end
    
    self.bubbles:emit()
end