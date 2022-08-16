Ball = class()
INITIAL_SPEED = 7

function Ball:init()
    self.position = vec2(WIDTH/2, HEIGHT/2)
    self.speed = vec2(INITIAL_SPEED, INITIAL_SPEED)
    self.direction = 1
    self.diameter = 20
    self.angle = 0
end

function Ball:update()
    -- update x and y position based on current speed
    self.position.x = self.position.x + self.speed.x
    self.position.y = self.position.y + self.speed.y
    self:keepInScreen()
end

function Ball:draw()
    pushStyle()
    
    noStroke()
    fill(255, 255, 255, 255)
    rectMode(CENTER)
    rect(self.position.x, self.position.y, self.diameter, self.diameter)
    
    popStyle()
end

-- called when the ball hits something
function Ball:ping()
    sound(SOUND_PICKUP, 1)
end

-- do some simple trigonometry to work out the new speed for a given angle
function Ball:setAngle(a)
    self.angle = a
    x = INITIAL_SPEED * math.sin(math.rad(self.angle))
    y = INITIAL_SPEED * math.cos(math.rad(self.angle))
    self.speed = vec2(x, y)
end

function Ball:increaseSpeed()
    if self.speed.x < 0 then self.speed.x = self.speed.x - 1 end
    if self.speed.x > 0 then self.speed.x = self.speed.x + 1 end
    if self.speed.y < 0 then self.speed.y = self.speed.y - 1 end
    if self.speed.y > 0 then self.speed.y = self.speed.y + 1 end
end

function Ball:keepInScreen()
    radius = self:radius()
    
    if self.position.x > WIDTH - radius then 
        -- if the ball has hit the right side
        self:ping()
        self.position.x = WIDTH - radius
        self.speed.x = self.speed.x * -1
    elseif self.position.x < radius then
        -- or if it's hit the left side
        self:ping()
        self.position.x = radius
        self.speed.x = self.speed.x * -1
    end
    
    if self.position.y > HEIGHT then 
        score(paddleA)
    elseif self.position.y < -self.diameter then
        score(paddleB)
    end
end

-- some useful functions to help when doing collisions
function Ball:radius()
    return self.diameter / 2
end

function Ball:left()
    return self.position.x - self:radius()
end

function Ball:right()
    return self.position.x + self:radius()
end

function Ball:top()
    return self.position.y + self:radius()
end

function Ball:bottom()
    return self.position.y - self:radius()
end