Paddle = class()

function Paddle:init(x, y, colour, name)
    self.position = vec2(x, y)
    self.colour = colour
    self.width = 100
    self.height = 20
    self.score = 0
    self.name = name
end

function Paddle:draw()
    pushStyle()
    
    noSmooth()
    strokeWidth(3)
    stroke(255, 255, 255, 255)
    fill(self.colour)
    rect(self.position.x - self:halfwidth(), self.position.y, self.width, self.height)
    
    popStyle()    
end

function Paddle:moveX(deltaX)
    self.position.x = self.position.x + deltaX
    if self.position.x < self:halfwidth() then self.position.x = self:halfwidth()
    elseif self.position.x > WIDTH - self:halfwidth() then 
        self.position.x = WIDTH - self:halfwidth() 
    end
end

-- basic rectangle collision check
function Paddle:collide(ball)
    if ball:right() > self:left() and
        ball:left() < self:right() and
        ball:top() > self:bottom() and
        ball:bottom() < self:top() then
        return true
    end
end

function Paddle:rebound(ball)
    sound(SOUND_PICKUP, 15)
    
    -- which direction do we need to resolve the collision?
    yup = math.abs(ball:bottom() - self:top())
    ydown = math.abs(ball:top() - self:bottom())
    
    -- vertical collision
    if yup < ydown then
        ball.position.y = ball.position.y + yup
    else
        ball.position.y = ball.position.y - ydown        
    end
    ball.speed.y = ball.speed.y * -1
end

-- some useful functions to help when doing collisions
function Paddle:halfwidth()
    return self.width / 2
end

function Paddle:center()
    return vec2(self.position.x, self.position.y + self.height / 2)
end

function Paddle:left()
    return self.position.x - self:halfwidth()
end

function Paddle:right()
    return self.position.x + self:halfwidth()
end

function Paddle:top()
    return self.position.y + self.height
end

function Paddle:bottom()
    return self.position.y
end