function setup()
    pixelSize = 1
end    

function draw3d()
    background()

    local self = {
        zoom = 1,
        n = 9,
        size = 20 / pixelSize,
        angle = elapsedTime * 2
    }

    isometric(self.zoom)    

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
            local offset = math.map(d, mind, maxd, -PI, PI)
            local s = sin(self.angle + offset)

            local h = math.map(s, -1, 1, w * 2, w * 8)
            local r = math.map(s, -1, 1, 0.4, 1)

            translate(0, 0, w)

            strokeSize(2)
            stroke(colors.gray)

            fill(Color(r))

            box(0, 0, 0, w, h, w)
        end
        popMatrix()
    end
end
