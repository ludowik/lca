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
end

function Graphics.points(...)
end

function Graphics.line()
end

function Graphics.lines()
end

function Graphics.rect(x, y, w, h)    
    if rectMode() == CENTER then
        x = x - w / 2
        y = y - h / 2
    end

    if not Graphics.rectMesh then
        local vertices = {}
        local x, y, w, h = 0, 0, 1, 1 
        table.insert(vertices, {x  , y  , 0, 0})
        table.insert(vertices, {x  , y+h, 0, 1})
        table.insert(vertices, {x+w, y+h, 1, 1})
        table.insert(vertices, {x  , y  , 0, 0})
        table.insert(vertices, {x+w, y+h, 1, 1})
        table.insert(vertices, {x+w, y  , 1, 0})
        Graphics.rectMesh = love.graphics.newMesh(vertices, 'triangles', 'static')
    end        

    local r, g, b, a = fill():unpack()

    pushMatrix()
    do
        translate(x, y)
        scale(w, h)

        love.graphics.setColor(r, g, b, a)
        love.graphics.draw(Graphics.rectMesh)

--    Graphics.flush()
    end
    popMatrix()
end

function Graphics.circle(x, y, r)
end

function Graphics.flush()
    if #vertices == 0 then return end

    local mesh = love.graphics.newMesh(vertices, 'triangles')
    love.graphics.draw(mesh)

    vertices = {}
end
