local Graphics = class 'GraphicsTemplate'

local vertices = {}
function Graphics:init()
    push2_G(Graphics)
end

function Graphics.fontSize(size)
end

function Graphics.textSize(txt)
end

function Graphics.text(txt, x, y)
    return GraphicsLove.text(txt, x, y)
end

function Graphics.point(x, y)
    Graphics.rect(
        x-strokeSize()*0.5,
        y-strokeSize()*0.5,
        strokeSize(),
        strokeSize(),
        {_fillColor=stroke()})
end

function Graphics.points(t)
    for i=1,#t,2 do
        Graphics.point(t[i], t[i+1])
    end
end

function Graphics.line(x1, y1, x2, y2)
    local v = vec2(x2, y2) - vec2(x1, y1)
    v = v:normalize(strokeSize()*0.5)
    v.x, v.y = -v.y, v.x
    
    local vertices = {}
    do
        table.insert(vertices, {x1-v.x, y1-v.y, 0, 0})
        table.insert(vertices, {x2-v.x, y2-v.y, 0, 0})
        table.insert(vertices, {x2+v.x, y2+v.y, 0, 0})
        table.insert(vertices, {x1-v.x, y1-v.y, 0, 0})
        table.insert(vertices, {x2+v.x, y2+v.y, 0, 0})
        table.insert(vertices, {x1+v.x, y1+v.y, 0, 0})
        
    end
    Graphics.lineMesh = love.graphics.newMesh(vertices, 'triangles', 'static')
    love.graphics.setColor(stroke():unpack())        
    love.graphics.draw(Graphics.lineMesh)
end

function Graphics.lines(t)
    love.graphics.setColor(stroke():unpack())
    love.graphics.setLineWidth(strokeSize())    
    for i=1,#t,4 do
        Graphics.line(t[i], t[i+1], t[i+2], t[i+3])
    end
end

function Graphics.polyline(t)
    love.graphics.setColor(stroke():unpack())
    love.graphics.setLineWidth(strokeSize())    
    local x, y = t[1], t[2]
    for i=3,#t,2 do
        Graphics.line(x, y, t[i], t[i+1])
        x, y = t[i], t[i+1]
    end
end

function Graphics.polygon(t)
    love.graphics.setColor(stroke():unpack())
    love.graphics.setLineWidth(strokeSize())    
    local x, y = t[1], t[2]
    for i=3,#t,2 do
        Graphics.line(x, y, t[i], t[i+1])
        x, y = t[i], t[i+1]
    end
    Graphics.line(x, y, t[1], t[2])
end

function Graphics.rect(x, y, w, h, attr)
    if rectMode() == CENTER then
        x = x - w / 2
        y = y - h / 2
    end

    if not Graphics.rectMesh then
        local vertices = {}
        local x, y, w, h = 0, 0, 1, 1
        do
            table.insert(vertices, {x  , y  , 0, 0})
            table.insert(vertices, {x  , y+h, 0, 1})
            table.insert(vertices, {x+w, y+h, 1, 1})
            table.insert(vertices, {x  , y  , 0, 0})
            table.insert(vertices, {x+w, y+h, 1, 1})
            table.insert(vertices, {x+w, y  , 1, 0})
        end
        Graphics.rectMesh = love.graphics.newMesh(vertices, 'triangles', 'static')
    end        

    pushMatrix()
    do
        translate(x, y)
        scale(w, h)

        local _fillColor = attr and attr._fillColor or fill()
        if _fillColor then
            love.graphics.setColor(_fillColor:unpack())
            love.graphics.draw(Graphics.rectMesh)
        end
    end
    popMatrix()
end

function Graphics.circle(x, y, radius)
    if circleMode() == CORNER then
        x = x - r
        y = y - r
    end

    if not Graphics.circleMesh then
        local vertices = {}
        local x, y, w, h = 0, 0, 1, 1 
        local nstep = 32
        table.insert(vertices, {x, y, 0, 0})
        for step = 0, nstep do
            local angle = TAU * step / nstep
            table.insert(vertices, {x+cos(angle), y+sin(angle), cos(angle), sin(angle)})
        end
        Graphics.circleMesh = love.graphics.newMesh(vertices, 'fan', 'static')
    end        

    pushMatrix()
    do
        translate(x, y)
        scale(radius, radius)

        if fill() then
            love.graphics.setColor(fill():unpack())        
            love.graphics.draw(Graphics.circleMesh)
        end
    end
    popMatrix()
end
