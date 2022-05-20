local Graphics = class 'GraphicsLove' : extends(GraphicsBase)

function Graphics:init()
    push2_G(Graphics)
    love.graphics.setLineStyle('smooth')
end

function Graphics.point(x, y)
    love.graphics.setColor(stroke():unpack())
    love.graphics.setPointSize(strokeSize())
    love.graphics.points(x, y)
end

function Graphics.points(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setPointSize(strokeSize())

    local format = {
        {"VertexPosition", "float", 2}, -- The x,y position of each vertex.
        -- {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
        {"VertexColor", "byte", 4} -- The r,g,b,a color of each vertex.
    }

    local mesh = love.graphics.newMesh(format, t, 'points', 'static')
    Graphics.drawMesh(mesh)
end

function Graphics.line(x1, y1, x2, y2)
    love.graphics.setColor(stroke():unpack())
    love.graphics.setLineWidth(strokeSize())
    love.graphics.line(x1, y1, x2, y2)
end

function Graphics.lines(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end

    love.graphics.setColor(stroke():unpack())
    love.graphics.setLineWidth(strokeSize())    
    for i=1,#t,4 do
        Graphics.line(t[i], t[i+1], t[i+2], t[i+3])
    end
end

function Graphics.polyline(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end

    love.graphics.setColor(stroke():unpack())
    love.graphics.setLineWidth(strokeSize())
    love.graphics.line(t)
end

function Graphics.polygon(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end

    love.graphics.setColor(stroke():unpack())
    love.graphics.setLineWidth(strokeSize())
    love.graphics.polygon('line', t)
end

function Graphics.rect(x, y, w, h)
    if rectMode() == CENTER then
        x = x - w / 2
        y = y - h / 2
    end

    if fill() then
        love.graphics.setColor(fill():unpack())
        love.graphics.rectangle('fill', x, y, w, h)
    end

    if stroke() then
        love.graphics.setColor(stroke():unpack())
        love.graphics.setLineWidth(strokeSize())
        love.graphics.rectangle('line', x, y, w, h)
    end
end

function Graphics.circle(x, y, r)
    if circleMode() == CORNER then
        x = x - r
        y = y - r
    end

    if fill() then
        love.graphics.setColor(fill():unpack())
        love.graphics.circle('fill', x, y, r)
    end

    if stroke() then
        love.graphics.setColor(stroke():unpack())
        love.graphics.setLineWidth(strokeSize())
        love.graphics.circle('line', x, y, r)
    end
end

function Graphics.ellipse(x, y, w, h)
    h = h or w
    
    if ellipseMode() == CORNER then
        x = x - r
        y = y - r
    end

    if fill() then
        love.graphics.setColor(fill():unpack())
        love.graphics.ellipse('fill', x, y, w/2, h/2)
    end

    if stroke() then
        love.graphics.setColor(stroke():unpack())
        love.graphics.setLineWidth(strokeSize())
        love.graphics.ellipse('line', x, y, w/2, h/2)
    end
end

local shape
function Graphics.beginShape()
    shape = Shape()
end

function Graphics.vertex(x, y)
    shape:vertex(x, y)
end

function Graphics.endShape()
    shape:draw()
    return shape
end

function Graphics.box(x, y, z, w, h, d)
    GraphicsCore.box(x, y, z, w, h, d)
end

function Graphics.sphere(x, y, z, r)
    GraphicsCore.sphere(x, y, z, r)
end

function Graphics.drawMesh(mesh)
    love.graphics.draw(mesh.mesh or mesh)
end
