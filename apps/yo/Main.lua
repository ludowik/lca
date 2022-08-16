function setup()
    --    viewer.mode = FULLSCREEN    
    
    W = WIDTH
    H = HEIGHT
    
    center = physics.body(CIRCLE, 20)
    center.type = KINEMATIC
    
    center.x = W/2
    center.y = H/2
    
    balls = {}
    addBall()
    
    parameter.watch('math.ceil(1/deltaTime)')
    parameter.watch('deltaTime')
    
    parameter.boolean('checkCollision', true)
    parameter.watch('checkCollisionsCount')
    parameter.integer('zoneSize', 10, 100, 20)
    parameter.number('speed', 0, 1000)
end

gravity = vec2(0, -9.80, 0)

function addBall(x, y)
--    table.insert(balls, Ball(x, y))
    local body = physics.body(CIRCLE, 20)
    body.x = x or W/2
    body.y = y or H/2
    
    physics.joint(ROPE, center, body, vec3(), vec3(), 400)
    
    table.insert(balls, body)
    
end

function update(dt)
    output.clear()
    
    checkCollisionsCount = 0
    
--    local n = 1
--    for i=1,n do
--        step(dt/n)
--    end
    
    speed = balls[#balls].linearVelocity:len()
end

function step(dt)
    -- dynamic
--    for i,b in ipairs(balls) do
--        b:addForce(gravity)
--        b:update(dt)
--    end

    -- area constraint
--    for i,b in ipairs(balls) do
--        local radius = 400
--        local position = vec2(W/2, H/2)
--        local direction = b.position - position
--        local dist = direction:len()
        
--        if dist > radius - b.radius then
--            local n = direction:normalize()
            
--            b.positionOld = b.position
--            b.position = position + n * (radius - b.radius)
            
--            --direction = b.position - position
            
--            local angle = b.velocity:angleBetween(direction)
--            b.velocity = -b.velocity:rotate(angle*2)
            
--            if b.velocity:len() > 500 then
--                b.velocity = b.velocity:normalize() * 10
--            else
--                b.velocity = b.velocity * math.pow(0.5, dt)
--            end
--        end
--    end
    
    if checkCollision then
        local zones = {}
        
        for _,b in ipairs(balls) do
            local i1 = math.floor((b.position.x-b.radius) / zoneSize)
            local j1 = math.floor((b.position.y-b.radius) / zoneSize)
            
            local i2 = math.floor((b.position.x+b.radius) / zoneSize)
            local j2 = math.floor((b.position.y+b.radius) / zoneSize)
            
            function addZone(i, j)
                zones[i..','..j] = zones[i..','..j] or {}
                table.insert(zones[i..','..j], b)
            end
            
            for i=i1,i2 do
                for j=j1,j2 do
                    addZone(i, j)
                end
            end
            
        end
        
        -- detect collisions
        function detectCollisions(balls)
            for i=1,#balls do                  
                local b1 = balls[i]
                for j=i+1,#balls do                  
                    local b2 = balls[j]
                    
                    checkCollisionsCount = checkCollisionsCount + 1
                        
                    local direction = b2.position - b1.position 
                    local dist = direction:len()
                    local distMax = b1.radius + b2.radius
                    if dist < distMax then
                        -- collision
                       -- 
                            
                        --b1.velocity, b2.velocity = b2.velocity, b1.velocity
                        
                        --local angle = b1.velocity:angleBetween(b2.velocity)
                        
                        local n = direction:normalize()
                        
                        local p = 2 * (b1.velocity.x * n.x + b1.velocity.y * n.y - b2.velocity.x * n.x - b2.velocity.y * n.y) / 
                        (b1.mass + b2.mass)
                        
                        b1.velocity.x = b1.velocity.x - p * b1.mass * n.x
                        b1.velocity.y = b1.velocity.y - p * b1.mass * n.y
                        
                        b2.velocity.x = b2.velocity.x + p * b2.mass * n.x
                        b2.velocity.y = b2.velocity.y + p * b2.mass * n.y
                            
                        direction = direction:normalize() * (distMax - dist)
                        b1.position = b1.position - direction / 2
                        b2.position = b2.position + direction / 2       
                    end
                end 
            end
        end
        
        for k,zone in pairs(zones) do
            detectCollisions(zone)
        end
    end
end

function draw()
    update(deltaTime)
    
    background(255)
    
    fill(0)
    ellipse(W/2, H/2, 800)
    
    physics.draw()
--    for i,v in ipairs(balls) do
--        v:draw()
--    end
end

function touched(touch)
    if 
        (touch.state == BEGAN) or
        (touch.state == CHANGED and touch.delta:len() > 20)
    then
        addBall(touch.x, touch.y)
    end
end

Ball = class()

function Ball:init(x, y)
    self.position = vec2(x or W/2, y or H/2)
    self.positionOld = self.position
    self.acceleration = vec2()
    self.velocity = vec2()
    self.radius = 20
    self.mass = 1
end

function Ball:applyForce(force)
--    self.acceleration = self.acceleration + force * 32
end

function Ball:update(dt)
--    self.velocity = self.velocity + self.acceleration * dt
--    self.positionOld = self.position
--    self.position = self.position + self.velocity * dt
--    self.acceleration = vec2()
    
--    -- linear damping
--    local damping = 0.8
--    self.velocity = self.velocity * math.pow(damping, dt)
end

function Ball:draw()
--    noStroke()
--    fill(self.velocity:len(), 0, 200)
--    ellipse(self.position.x, self.position.y, 2 * self.radius)
end
