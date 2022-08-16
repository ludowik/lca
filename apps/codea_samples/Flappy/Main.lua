-- Flappy
viewer.mode = FULLSCREEN

MENU = 0
PLAYING = 1
GAMEOVER = 3
ICONS = {"🍓", "🍏", "🍒"} --🍎🍊🍋🍒🍇🍉🍩🍦🍪🍰🌽🍌🍐🍔🍗"

-- Use this function to perform your initial setup
function setup()    
    reset()
end

function reset()
    speed = 150
    spacing = 350
    maxGap = 130
    gravity = -800
    pipeWidth = 100
    flapperForce = 310
    camera = 0
    local c = math.random(1,#ICONS)
    postfix = ICONS[c]
    gameOverTimer = 0
    
    
    if flapper == nil then
        flapper = Flapper(WIDTH/2, HEIGHT/2, speed)
    else
        flapper.body.position = vec2(WIDTH/2, HEIGHT/2)
    end
    flapper:reset()
    
    -- set gravity
    physics.gravity(0, gravity)
    
    -- start on menu
    state = MENU
    
    -- create empty list of pipes
    clear()
    next = flapper.body.x + WIDTH*0.5
    scoreLine = next
    gapHeight = HEIGHT/2
    score = {count = 0, y = HEIGHT*0.75}
    spawnNext()
    
    -- start game paused
    physics.pause()
end

function start()
    physics.resume()
    state = PLAYING
end

function gameOver()
    state = GAMEOVER
    if readLocalData("score") == nil or score.count > readLocalData("score") then
        saveLocalData("score", score.count)
    end
    gameOverTimer = 0.25
    physics.pause()
    tween(1.5, score, {y = HEIGHT/2}, tween.easing.cubicInOut)
end

function clear()
    if pipes then
        for key,pipe in pairs(pipes) do
            pipe.body:destroy()
            pipe:draw()
        end
    end
    pipes = {}
end

function spawnNext()
    addPipes(next, gapHeight, maxGap)
    next = next + spacing
    gapHeight = math.random(math.floor(HEIGHT*0.25), math.floor(HEIGHT*0.75))
end

function addPipes(x, y, gap)
    table.insert(pipes, Pipe(x, y - gap/2, false))
    table.insert(pipes, Pipe(x, HEIGHT - y - gap/2, true))
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color
    background(42, 131, 208, 255)
    
    if not flapper.dead then
        camera = -flapper.body.x + WIDTH*0.25
    end
    
    pushMatrix()
    translate(camera, 0)
    
    flapper:draw()   
    
    for key,pipe in pairs(pipes) do
        pipe:draw()
    end
    
    if flapper.body.x + WIDTH*0.75 + 300 > next then
        spawnNext()
    end
    
    if flapper.dead == false and flapper.body.x > scoreLine then
        scoreLine = scoreLine + spacing
        score.count = score.count + 1
        sound(SOUND_PICKUP, 8630)
    end
    
    local seg = 100
    local offset = -camera-2*seg
    for i = offset, offset + WIDTH + seg * 6, seg do
        sprite("Platformer Art:Water", i - (offset * 1.5 + ElapsedTime * seg) % seg, 25, seg)
    end
    
    popMatrix()
    
    if state == MENU then
        fill(255, 255, 255, 255)
        textAlign(CENTER)
        font("Arial-BoldMT")
        fontSize(40)
        text("Touch to flap", WIDTH * 0.35, HEIGHT * 0.4)
    elseif state == PLAYING then
        drawScore()
        
        -- check if hitting ceiling or floor
        if flapper.body.y > HEIGHT or flapper.body.y < 0 then
            flapper:kill()
            gameOver()
        end
    elseif state == GAMEOVER then
        drawScore()
        
        if gameOverTimer > 0 then
            gameOverTimer = gameOverTimer - DeltaTime
        else
            physics.resume()
            flapper.shake = false
        end
        
    end
    
    -- draw high score text
    if readLocalData("score") then
        fill(255, 255, 255, 255)
        font("Arial-BoldMT")
        textAlign(LEFT)
        fontSize(20)
        local score = math.tointeger(readLocalData("score"))
        text("HIGH "..score, 75, HEIGHT - layout.safeArea.top - 18)
    end
    
end

function drawScore()
    fill(255, 255, 255, 255)
    textAlign(CENTER)
    font("Arial-BoldMT")
    fontSize(60)
    text(""..score.count, WIDTH/2 -20, score.y)
    text(postfix, WIDTH/2 + textSize(""..score.count), score.y)
end


function touched(touch)
    if touch.state == BEGAN then
        if state == MENU then
            start()
            flapper:flap()
        elseif state == PLAYING then
            flapper:flap()
        elseif state == GAMEOVER and gameOverTimer <= 0 then
            reset()
        end
    end
end

function collide(contact)
    if contact.state == BEGAN and state == PLAYING then
        flapper:kill(contact)
        gameOver()
    end
end
