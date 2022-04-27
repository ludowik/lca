require 'lua/debug'
require 'lua/class'
require 'lua/table'
require 'lua/convert'
require 'lua/string'

require 'lua_collection/__init'

require 'maths/math'
require 'maths/vec2'
require 'maths/vec3'
require 'maths/vec4'
require 'maths/matrix'
require 'maths/transform'

require 'engine/love'
require 'engine/event'

require 'graphics/colors'
require 'graphics/graphics'
require 'graphics/camera'
require 'graphics/mesh'
require 'graphics/meshRender'

require 'lua/global'

global.ffi = require 'ffi'

--------------------------------------------------------------------------------
strokeWidth = lineWidth
Vec2 = vec2
Vec3 = vec3
color = Color
box = cube
--------------------------------------------------------------------------------

local mode = -1
local sqrt = math.sqrt

function update(dt)
    if mode >= 0 then mode = (mode + 1) % 6 end

    getCamera():update(dt)
end

function draw()
    background(colors.black:alpha(0.01))

    resetMatrix(true)
    ortho()
    draw2d()

    resetMatrix(true)
    perspective()
    isometric()
    -- draw3d()
end

function draw2d()
    blendMode(ADD)

    translate(W / 2, H / 2)

    if mode == -1 then
        point(125, 125, colors.blue)

        line(0, 0, 125, 0)

        circle(125, 0, 8, colors.blue)

        rect(-75, -50, 100, 100, colors.red)
        rect(-25, -50, 100, 100, colors.green)

        ellipse(0, 0, 25, 50, Color(0, 0, .1))

        beginShape()
        vertex(200, 0)
        vertex(0, 200)
        vertex(-200, 0)
        vertex(0, -200)
        vertex(200, 0)
        endShape()

    elseif mode == 0 then
        pointSize(math.random(10))
        point(math.random(W), math.random(H), Color.random())

    elseif mode == 1 then
        lineWidth(math.random(10));
        line(math.random(W), math.random(H), math.random(W), math.random(H),
             Color.random())

    elseif mode == 2 then
        rect(math.random(W), math.random(H), math.random(100), math.random(100),
             Color.random())

    elseif mode == 3 then
        circle(math.random(W), math.random(H), math.random(100), Color.random())

    elseif mode == 4 then
        ellipse(math.random(W), math.random(H), math.random(100),
                math.random(100), Color.random())

    elseif mode == 5 then
        beginShape()
        for i = 3, 3 + math.random(5) do
            vertex(math.random(W), math.random(H))
        end
        endShape()

    end
end

function draw()
    background(colors.black)
    local self = {
        zoom = 1,
        n = 13,
        size = 10 / pixelSize,
        angle = elapsedTime * 10
    }

    isometric(self.zoom)

    -- depthMode(true)
    -- cullingMode(true)

    local n = self.n * 2 + 1

    local w = self.size

    local mind = 0
    local maxd = vec2(1, 1):dist(vec2(n / 2, n / 2))

    translate(-(n + 1) / 2 * w, 0, -(n + 1) / 2 * w)

    for x = 1, n do
        translate(w, 0, 0)

        pushMatrix()
        for z = 1, n do
            local d = vec2(x, z):dist(vec2((n + 1) / 2, (n + 1) / 2))
            local offset = math.map(d, mind, maxd, -math.PI, math.PI)
            local s = sin(self.angle + offset)

            local h = map(s, -1, 1, w * 2, w * 8)
            local r = map(s, -1, 1, 0, 1)

            translate(0, 0, w)

            strokeWidth(2)
            stroke(gray)

            fill(color(r))

            box(w, h, w)
        end
        popMatrix()
    end
end

function keypressed(key) if key == 't' then mode = -1 end end
