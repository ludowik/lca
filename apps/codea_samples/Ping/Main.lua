
ball = nil
paddleA = nil
paddleB = nil
startTime = nil
resetDelay = nil
timediff = nil
pointer = nil
bounces = 0
gamestart = true

-- Use this function to perform your initial setup
function setup()
    viewer.mode = FULLSCREEN
    
    print("Tap to start!")
    print("First to 5 wins")

    reset(nil)        -- reset the game state
    resetDelay = 360  -- time until the ball moves without user intervention

    paddleA = Paddle(WIDTH/2, 40, color(0, 158, 255, 255), "Blue")
    paddleB = Paddle(WIDTH/2, HEIGHT - 60, color(0, 255, 158, 255), "Green")
end

function reset(paddle)
    startTime = ElapsedTime
    resetDelay = 2            -- 2 second delay until the ball moves

    if not ball then ball = Ball() end     -- create a ball if one doesn't exist
    ball.position = vec2(WIDTH/2, HEIGHT/2)

    -- set up the ball angle indicator
    if paddle == nil then
        direction = randomDirection()
    elseif paddle == paddleA then
        direction = "down"
    elseif paddle == paddleB then
        direction = "up"
    end
    pointer = Pointer(direction)
end

-- one player has scored a point
function score(paddle)
    paddle.score = paddle.score + 1
    sound(SOUND_PICKUP, 17)
    reset(paddle)

    if paddle.score == 5 then
        win(paddle)
    end
end

function win(paddle)
    print(paddle.name .. " wins!")
    sound(SOUND_SHOOT, 1)
    resetDelay = 360
    gamestart = true
    paddleA.position.x = WIDTH / 2
    paddleB.position.x = WIDTH / 2
end

-- This function gets called once every frame
function draw()
    update()

    background(35, 40, 70, 255)

    noSmooth()
    strokeWidth(2)
    stroke(70, 86, 129, 39)
    line(0, HEIGHT / 2, WIDTH, HEIGHT / 2)

    if (pointer and resetDelay <= 2) then pointer:draw() end

    drawScores()
    paddleA:draw()
    paddleB:draw()
    ball:draw()
end

function update()
    -- if the game is being reset, then either do nothing or just update the angle pointer
    if (resetDelay) then
        timediff = ElapsedTime - startTime
        if (timediff < resetDelay) then
            return
        else
            ball:setAngle(pointer.angle)
            pointer = nil
            resetDelay = nil
        end
    end

    ball:update()

    -- check for collisions
    if paddleA:collide(ball) then
        bounces = bounces + 1
        paddleA:rebound(ball)
    elseif paddleB:collide(ball) then
        bounces = bounces + 1
        paddleB:rebound(ball)
    end

    -- every 5 bounces, increase speed!
    if bounces == 5 then
        ball:increaseSpeed()
        bounces = 0
    end
end

function touched(t)
    if gamestart == true and t.state == BEGAN then
        reset(nil)
        gamestart = false
        paddleA.score = 0
        paddleB.score = 0
    end

    if t.state == MOVING and t.y < HEIGHT/2 then
        paddleA:moveX(t.deltaX)
    elseif t.state == MOVING and t.y > HEIGHT/2 then
        paddleB:moveX(t.deltaX)
    end
end

function drawScores()
    -- bottom
    for i=1,paddleA.score do
        pushStyle()
        noSmooth()
        strokeWidth(2)
        stroke(255,255,255,255)
        fill(paddleA.colour)
        rect(12, (HEIGHT / 2) - 24*i, 12, 12)
        popStyle()
    end
    -- top
    for i=1,paddleB.score do
        pushStyle()
        noSmooth()
        strokeWidth(2)
        stroke(255,255,255,255)
        fill(paddleB.colour)
        rect(12, (HEIGHT / 2) + 24*i - 12, 12, 12)
        popStyle()
    end
end

-- select a random player for the ball to aim at
function randomDirection()
    i = math.random(0,1)
    if i == 0 then
        return "up"
    else
        return "down"
    end
end