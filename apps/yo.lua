function setup()
    setOrigin(BOTTOM_LEFT)

    area = Area2()

    balls = table()
    table.insert(balls, Ball(150, 100, 20):addVelocity(vec3(100, 0)))
    table.insert(balls, Ball(300, 100, 20))
end

local gravity = vec3(0, -980, 0)

function update(dt)
    for i=1,10 do
        step(dt/10)
    end
end

function step(dt)    
    balls:foreach(function (i, ball)
--            ball:addForce(gravity)
            ball:update(dt)
            area:constraint(ball)
        end)

    for i,b1 in ipairs(balls) do
        for i,b2 in ipairs(balls) do
            if b1 ~= b2 then
                local direction = b2.position - b1.position
                local dist = direction:len() - b1.radius - b2.radius
                if dist < 0 then
                    b1.position = b1.position + direction:normalize(dist/2)
                    b2.position = b2.position + direction:normalize(-dist/2)
                    
--                    local b1v, b2v = b1.velocity, b2.velocity
--                    b1.velocity = b2.velocity
--                    b2.velocity = b1.velocity
                end
            end
        end
    end
end

function draw()
    background(colors.black)

    area:draw()
    balls:draw()
end

function touched(touch)
    if touch.state == BEGAN then
        table.insert(balls, Ball(touch.x, touch.y))
    end
end

class 'Area'

function Area:init()
    self.position = vec3(W/2, H/2)
    self.radius = 250
end

function Area:constraint(ball)
    local direction = ball.position - self.position
    local dist = direction:len()

    if dist > self.radius - ball.radius then
        ball.position = self.position + direction:normalize(self.radius - ball.radius)
    end    
end

function Area:draw()
    stroke(colors.white)
    noFill()
    circle(self.position.x, self.position.y, self.radius)
end

class 'Area2'

function Area2:init()
    self.position = vec3(100, 100)
    self.size = vec3(W-200, H-200)
end

function Area2:constraint(ball)
    if ball.position.x - ball.radius < self.position.x then
--        local velocity = ball.position - ball.positionOld
        ball.velocity.x = -ball.velocity.x
        ball.position.x = self.position.x + ball.radius + (self.position.x - (ball.position.x - ball.radius))
--        ball.positionOld = ball.position - velocity
    end

    if ball.position.y - ball.radius < self.position.y then
--        local velocity = ball.position - ball.positionOld
        ball.velocity.y = -ball.velocity.y
        ball.position.y = self.position.y + ball.radius + (self.position.y - (ball.position.y - ball.radius))
--        ball.positionOld = ball.position - velocity
    end

    if ball.position.x + ball.radius > self.position.x + self.size.x then
--        local velocity = ball.position - ball.positionOld
        ball.velocity.x = -ball.velocity.x
        ball.position.x = self.position.x + self.size.x - ball.radius - (ball.position.x + ball.radius - (self.position.x + self.size.x))
--        ball.positionOld = ball.position - velocity
    end
    
    if ball.position.y + ball.radius > self.position.y + self.size.y then
--        local velocity = ball.position - ball.positionOld
        ball.velocity.y = -ball.velocity.y
        ball.position.y = self.position.y + self.size.y - ball.radius - (ball.position.y + ball.radius - (self.position.y + self.size.y))
--        ball.positionOld = ball.position - velocity
    end
end

function Area2:draw()
    stroke(colors.white)
    noFill()
    rect(self.position.x, self.position.y, self.size.x, self.size.y)
end


class 'Ball'

function Ball:init(x, y, radius)
    self.position = vec3(x or random(W), y or H/2)
    self.velocity = vec3()
--    self.positionOld = self.position
    self.acceleration  = vec3()
    self.radius = radius or randomInt(10, 25)
end

function Ball:addVelocity(velocity)
--    self.positionOld = self.position - velocity
    self.velocity = self.velocity + velocity
    return self
end

function Ball:addForce(force)
    self.acceleration  = self.acceleration + force
end

function Ball:update(dt)
--    local velocity = self.position - self.positionOld
--    self.positionOld = self.position
    self.velocity = self.velocity + self.acceleration * dt
    self.position = self.position + self.velocity * dt
    self.acceleration = vec3()
end

function Ball:draw()
    fill(red)
    circle(self.position.x, self.position.y, self.radius)
end
