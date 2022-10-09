local x = 0.01
local y = 0
local z = 0

local a = 10
local b = 28
local c = 8.0 / 3.0

points = table()

function setup()
    --colorMode(HSB)

    parameter.watch('#points')
    camera(30,30,30)
end

function draw3d()
    background()

    perspective()

    local dt = 0.01
    local dx = (a * (y - x)) * dt
    local dy = (x * (b - z) - y) * dt
    local dz = (x * y - c * z) * dt

    x = x + dx
    y = y + dy
    z = z + dz

    points:add(vec3(x, y, z))

    translate(W/2, H/2, -80)

    local camX = map(mouse.x, 0, W, -200, 200)
    local camY = map(mouse.y, 0, H, -200, 200)

    camera(camX, camY, -(H / 2.0) / tan(PI * 30.0 / 180.0))

    --translate(W/2, H/2)

    --scale(50)
    stroke(255)
    --noFill()

    if #points <3 then return end

    local hu = 0
    beginShape()
    for i,v in ipairs(points) do
        --stroke(hu, 255, 255)
        vertex(v.x, v.y, v.z)

        hu = hu + 1

        if hu > 255 then
            hu = 0
        end
    end
    endShape()
end
