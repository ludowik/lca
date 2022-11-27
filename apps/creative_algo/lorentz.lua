local x = 0.01
local y = 0
local z = 0

local a = 10
local b = 28
local c = 8.0 / 3.0

points = table()

function setup()
    parameter.watch('#points')
    camera(0, 0, 1)
end

local function step(dt)
    local dx = (a * (y - x)) * dt
    local dy = (x * (b - z) - y) * dt
    local dz = (x * y - c * z) * dt

    x = x + dx
    y = y + dy
    z = z + dz

    points:add(vec3(x, y, z))
end

function update(dt)
    for i = 1,100 do
        step(dt/10)
    end
end

function draw()
    background()

    perspective()
    
    scale(2/W)
    
    strokeSize(0.1)
    stroke(colors.blue)
    
    noFill()
    
    local camX = map(mouse.x, 0, W, -200, 200)
    local camY = map(mouse.y, 0, H, -200, 200)

    --camera(camX, camY, -(H / 2.0) / tan(PI * 30.0 / 180.0))

    stroke(colors.white)
    
    if #points <3 then return end

    local hu = 0
    
    beginShape()
    for i,v in ipairs(points) do
        stroke(Color.hsl(hu, 1, 1))
        
        vertex(v.x, v.y, v.z)

        hu = hu + 1

        if hu > 255 then
            hu = 0
        end
    end
    endShape()
end
