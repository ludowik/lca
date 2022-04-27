local min, max, floor, ceil, cos, sin = math.min, math.max, math.floor,
                                        math.ceil, math.cos, math.sin

DEGREES = 'degrees'
RADIANS = 'radians'
function angleMode() return RADIANS end

function REPLACE(s, t, a) return s end

function MIX(s, t, a) return s * a + (1 - a) * t end

function ADD(s, t, a) return s + t end

local _blendMode = REPLACE
function blendMode(mode)
    _blendMode = mode or _blendMode
    return _blendMode
end

local _strokeColor
function stroke(clr)
    if clr then _strokeColor = clr end
    return _strokeColor
end

local _fillColor
function fill(clr)
    if clr then _fillColor = clr end
    return _fillColor
end

function tocolor(clr, ...)
    if clr then return Color.tocolor(clr, ...) end
    return _fillColor
end

local _pointSize = 3
function pointSize(size) _pointSize = size or _pointSize end

function point(x, y, ...)
    rect(x - _pointSize / 2, y - _pointSize / 2, _pointSize, _pointSize, ...)
end

local _lineWidth = 3
function lineWidth(size) _lineWidth = size or _lineWidth end

function line(x1, y1, x2, y2, ...)
    local v = Vec2(x2, y2) - Vec2(x1, y1)
    v:normalizeInPlace(_lineWidth / 2)
    v.x, v.y = -v.y, v.x

    local vertices = {
        Vec2(x1, y1) + v, Vec2(x2, y2) + v, Vec2(x2, y2) - v, Vec2(x1, y1) + v,
        Vec2(x2, y2) - v, Vec2(x1, y1) - v
    }

    drawMesh(Mesh(vertices, tocolor(...)))
end

function bresenhamLine(x1, y1, x2, y2, ...)
    local dx = math.abs(x2 - x1)
    local dy = math.abs(y2 - y1)

    local sx = (x1 < x2) and 1 or -1
    local sy = (y1 < y2) and 1 or -1

    local err = dx - dy

    while (true) do
        point(x1, y1, ...)

        if (math.abs(x2 - x1) < 1 and math.abs(y2 - y1) < 1) then break end

        local e2 = 2 * err

        if (e2 > -dy) then
            err = err - dy
            x1 = x1 + sx
        end

        if (e2 < dx) then
            err = err + dx
            y1 = y1 + sy
        end
    end
end

function rect(x, y, w, h, ...)
    local x1, y1 = x, y
    local x2, y2 = x + w, y
    local x3, y3 = x + w, y + h
    local x4, y4 = x, y + h

    local vertices = table()
    vertices:addItems({
        Vec2(x1, y1), Vec2(x2, y2), Vec2(x3, y3), Vec2(x1, y1), Vec2(x3, y3),
        Vec2(x4, y4)
    })

    drawMesh(Mesh(vertices, tocolor(...)))
end

function circle(x, y, r, ...) ellipse(x, y, r * 2, r * 2, ...) end

local cosValues, sinValues
function ellipse(x, y, w, h, ...)
    local rw = w / 2
    local rh = h / 2

    local n = 16

    if true or not cosValues then
        local da = math.TAU / n

        cosValues = {}
        sinValues = {}

        local angle = 0
        for i = 1, n do
            cosValues[i] = cos(angle)
            sinValues[i] = sin(angle)
            angle = angle + da
        end

        cosValues[n + 1] = cosValues[1]
        sinValues[n + 1] = sinValues[1]
    end

    local x1, y1 = x + cosValues[1] * rw, y + sinValues[1] * rh
    local x2, y2

    local vertices = table()

    for i = 2, n + 1 do
        x2, y2 = x + cosValues[i] * rw, y + sinValues[i] * rh
        vertices:push(Vec2(x, y))
        vertices:push(Vec2(x2, y2))
        vertices:push(Vec2(x1, y1))
        x1, y1 = x2, y2
    end

    drawMesh(Mesh(vertices, tocolor(...)))
end

local vertices
function beginShape() vertices = table() end

function vertex(x, y) vertices:push(Vec2(x, y)) end

function endShape()
    local v1, v2 = vertices[1]
    for i = 2, #vertices do
        v2 = vertices[i]
        line(v1.x, v1.y, v2.x, v2.y, colors.white)
        v1 = v2
    end
end

local __vertices
local __colors
function cube(w, h, d)
    w, h, d = w or 1, h or 1, d or 1

    if not __vertices then
        __vertices = table()
        __vertices:addItems({ -- 
            vec3(-1, -1, -1), vec3(1, -1, -1), vec3(1, 1, -1), vec3(-1, -1, -1),
            vec3(1, 1, -1), vec3(-1, 1, -1), --
            vec3(-1, -1, 1), vec3(-1, -1, -1), vec3(-1, 1, -1), vec3(-1, -1, 1),
            vec3(-1, 1, -1), vec3(-1, 1, 1), --
            vec3(1, -1, 1), vec3(-1, -1, 1), vec3(-1, 1, 1), vec3(1, -1, 1),
            vec3(-1, 1, 1), vec3(1, 1, 1), --
            vec3(1, -1, -1), vec3(1, -1, 1), vec3(1, 1, 1), vec3(1, -1, -1),
            vec3(1, 1, 1), vec3(1, 1, -1), --
            vec3(-1, 1, -1), vec3(1, 1, -1), vec3(1, 1, 1), vec3(-1, 1, -1),
            vec3(1, 1, 1), vec3(-1, 1, 1), --
            vec3(-1, -1, 1), vec3(1, -1, 1), vec3(1, -1, -1), vec3(-1, -1, 1),
            vec3(1, -1, -1), vec3(-1, -1, -1)
        })
        assert(#__vertices == 36)

        __colors = table()
        __colors:addItems({ --
            colors.green, colors.green, colors.green, colors.green,
            colors.green, colors.green, --
            colors.red, colors.red, colors.red, colors.red, colors.red,
            colors.red, --
            colors.blue, colors.blue, colors.blue, colors.blue, colors.blue,
            colors.blue, --
            colors.white, colors.white, colors.white, colors.white,
            colors.white, colors.white, --
            colors.yellow, colors.yellow, colors.yellow, colors.yellow,
            colors.yellow, colors.yellow, --
            colors.gray, colors.gray, colors.gray, colors.gray, colors.gray,
            colors.gray
        })
        assert(#__colors == 36)
    end

    local m = Mesh(__vertices)
    m.colors = __colors

    pushMatrix()
    scale(w / 2, h / 2, d / 2)
    drawMesh(m)
    popMatrix()
end
