Pointer = class()

-- Pointer is the ball direction pointer that appears before each round
function Pointer:init(direction)
    self.origin = vec2(WIDTH/2, HEIGHT/2)
    self.length = 50
    self.direction = direction
    if self.direction == "up" then
        self.angle = math.random(315, 405)
    else
        self.angle = math.random(135, 225)
    end
    self.speed = 2
end

function Pointer:update()
    self.angle = self.angle + self.speed
    
    -- reverse direction if the angle is too far to either side
    if self.direction == "up" then
        if self.angle <= 315 and self.angle >= 45 then self.speed = self.speed * -1 end
    else
        if (self.angle >= 225 and self.angle <= 360) or 
           (self.angle <= 135 and self.angle >= 0) then self.speed = self.speed * -1 end
    end
    
    -- if the angle passes over 360, or below 0, wrap it round
    if self.angle < 0 then 
        self.angle = 360 - self.angle
    elseif self.angle > 360 then 
        self.angle = self.angle - 360
    end
end

function Pointer:draw()
    self:update()
    
    -- calculate the new endpoints of the line based on the angle and length
    endpoint = vec2()
    endpoint.x = self.length * math.sin(math.rad(self.angle)) + self.origin.x
    endpoint.y = self.length * math.cos(math.rad(self.angle)) + self.origin.y
    
    pushStyle()
    
    noSmooth()
    strokeWidth(1)
    stroke(255, 255, 255, 255)
    line(self.origin.x, self.origin.y, endpoint.x, endpoint.y)
    
    popStyle()
end