--# Main
-- Hooper
viewer.mode = FULLSCREEN

-- Physics categories
POLE = 1
GROUND = 2
HOOP_EDGE = 3
HOOP_MIDDLE = 4

function setup()
    print("Hello Physics!")
    helper = PhysicsHelper()

    parameter.boolean("drawPhysicsDebug", false)
    reset()
end

function reset()
    helper:clear()

    -- Edges of the case
    leftEdge = 25
    rightEdge = WIDTH-25
    bottomEdge = 25
    topEdge = HEIGHT-50
    caseColor = color(163, 24, 24, 255)

    -- How far from the bottom of the screen is floor
    baseOffset = 200
    -- The height of the central peak
    local peakHeight = baseOffset + 45
    local peakWidth = WIDTH*0.75

    local hoopCount = 12

    -- Hoop colours
    local colors = {color(255, 0, 37, 255),
    color(251, 255, 0, 255),
    color(11, 255, 0, 255),
    color(0, 13, 255, 255)}

    -- Create the base physics body
    base = physics.body(POLYGON, vec2(leftEdge,0),
    vec2(rightEdge, 0), vec2(rightEdge, 0), vec2(rightEdge, baseOffset), vec2(WIDTH/2 + peakWidth/2, baseOffset), vec2(WIDTH/2, peakHeight), vec2(WIDTH/2 - peakWidth/2, baseOffset), vec2(leftEdge,baseOffset))
    base.type = STATIC
    base.friction = 0
    helper:addBody(base)

    -- Mesh to render the base
    baseMesh = mesh()
    baseMesh.vertices = triangulate(base.points)

    -- Create walls to stop hoops from leaving the case
    wallThickness = 10
    left = makeBox(leftEdge+wallThickness/2, HEIGHT/2, 10, WIDTH)
    left.type = STATIC
    helper:addBody(left)

    right = makeBox(rightEdge-wallThickness/2, HEIGHT/2, 10, HEIGHT)
    right.type = STATIC
    helper:addBody(right)

    top = makeBox(WIDTH/2, topEdge-wallThickness/2, WIDTH, 10)
    top.type = STATIC
    helper:addBody(top)

    -- Create the bubble jets to apply force to hoops
    leftJet = BubbleJet(100,baseOffset+150,200,300, 40)
    rightJet = BubbleJet(WIDTH-100, baseOffset+150,200,300, 40)

    -- Buttons t activate the jets
    leftButton = Button(WIDTH*0.2, 90, 150, function() leftJet:activate() end)
    rightButton = Button(WIDTH*0.8, 90, 150, function() rightJet:activate() end)

    -- Tables to keep track of poles and hoops
    poles = {}
    hoops = {}

    -- Setup the poles and add to list
    table.insert(poles, Pole(WIDTH/2, HEIGHT*0.8, helper))
    table.insert(poles, Pole(WIDTH*0.3, HEIGHT*0.6, helper))
    table.insert(poles, Pole(WIDTH*0.7, HEIGHT*0.6, helper))

    -- Randomly place the hoops near the center of the case
    for i = 1,hoopCount do
        local col = colors[i%4+1]
        table.insert(hoops, Hoop(WIDTH/2 + math.random(-20,20), baseOffset + 30 + 10 * i, col, helper))
    end

end


function draw()
    background(67, 149, 169, 255)

    -- Use accelerometer to set physics gravity
    local g = Gravity
    g.y = g.y * 0.25 -- tone it down a bit to simulate water
    physics.gravity( g )

    -- Draw an air bubble based on device tilt
    local tilt = math.min(math.max(-g.x, -1),1)
    pushStyle()
    noStroke()
    fill(255, 255, 255, 100)
    blendMode(ADDITIVE)
    ellipseMode(CENTER)
    ellipse(WIDTH/2 + tilt * (WIDTH/2-30), topEdge - 25, 70, 45)
    popStyle()

    -- draw ground using several copies to give 3d effect
    pushMatrix()
    translate(0,10)
    blendMode(ADDITIVE)
    baseMesh:setColors(color(120,120,120,120))
    baseMesh:draw()
    popMatrix()

    pushMatrix()
    translate(0,-10)
    baseMesh:setColors(color(110,110,110,110))
    baseMesh:draw()
    popMatrix()
    blendMode(NORMAL)

    -- Draw back half of hoops so they can go behind stuff
    for k,v in pairs(hoops) do
        v:drawBack()
    end

    -- Draw poles so they go through hoops
    for k,pole in pairs(poles) do
        pole:draw()
    end

    -- Draw front hald of hoops so they go infront of everything else
    for k,hoop in pairs(hoops) do
        hoop:draw()
    end

    -- Debug physics drawing to see how everything works
    if drawPhysicsDebug then
        helper:draw()
    end

    leftJet:draw()
    rightJet:draw()

    -- Draw case around everything
    pushStyle()

    blendMode(NORMAL)
    fill(caseColor)
    noStroke()
    noSmooth()
    rect(leftEdge, topEdge, rightEdge-leftEdge, HEIGHT-topEdge)
    rect(leftEdge, 0, rightEdge-leftEdge, baseOffset-20)

    fill(45, 45, 45, 255)
    rect(0,0, leftEdge, WIDTH)
    rect(rightEdge,0, WIDTH-rightEdge, HEIGHT)

    leftButton:draw()
    rightButton:draw()

    -- Draw highlights on the edges of the case
    strokeWidth(20)
    blendMode(ADDITIVE)
    stroke(255, 255, 255, 57)
    lineCapMode(SQUARE)
    line(leftEdge+strokeWidth(), 0, leftEdge+strokeWidth(), HEIGHT)
    line(rightEdge-strokeWidth(), 0, rightEdge-strokeWidth(), HEIGHT)
    strokeWidth(10)
    line(leftEdge+strokeWidth(), 0, leftEdge+strokeWidth(), HEIGHT)
    line(rightEdge-strokeWidth(), 0, rightEdge-strokeWidth(), HEIGHT)
    popStyle()

    -- Draw the case label
    textAlign(CENTER)
    font("Noteworthy-Bold")
    fontSize(35)
    fill(255, 208, 0, 255)
    text("Hoop 'n Bubbles", WIDTH/2 + 1, 99)
    fill(157, 145, 51, 255)
    text("Hoop 'n Bubbles", WIDTH/2, 100)
end

function touched(touch)
    helper:touched(touch)
    leftButton:touched(touch)
    rightButton:touched(touch)
end

function makeBox(x,y,w,h)
    local body = physics.body(POLYGON,vec2(-w/2, h/2),
    vec2(-w/2, -h/2), vec2(w/2, -h/2), vec2(w/2, h/2))
    body.x = x
    body.y = y
    return body
end
