local Graphics = class 'GraphicsTemplate'

function Graphics:init()
    push2_G(Graphics)
    love.graphics.setLineStyle('smooth')    
end

function Graphics.clip(...)
    love.graphics.setScissor(...)
end

function Graphics.fontSize(size)
    return GraphicsLove.fontSize(size)
end

function Graphics.textSize(txt)
    return GraphicsLove.textSize(txt)
end

function Graphics.text(txt, x, y)
    return GraphicsLove.text(txt, x, y)
end

function Graphics.point(x, y)
    Graphics.rect(
        x - strokeSize() * .5,
        y - strokeSize() * .5,
        strokeSize(),
        strokeSize(),
        {
            _fillColor = stroke()
        })
end

function Graphics.points(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end
    for i=1,#t do
        Graphics.point(t[i][1], t[i][2])
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

function Graphics.lines(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end
    
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

function Graphics.box(x, y, z, w, h, d)
    if not Graphics.boxMesh then
        local vertices = {}
        local x, y, z, w, h, d = 0, 0, 0, 1, 1, 1
        local format = {
            {"VertexPosition", "float", 3}, -- The x,y position of each vertex.
            -- {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
            -- {"VertexColor", "byte", 4} -- The r,g,b,a color of each vertex.
        }

        -- front
        table.insert(vertices, {x-w, y-h, z-d})
        table.insert(vertices, {x+w, y-h, z-d})
        table.insert(vertices, {x+w, y+h, z-d})
        table.insert(vertices, {x-w, y-h, z-d})
        table.insert(vertices, {x+w, y+h, z-d})
        table.insert(vertices, {x-w, y+h, z-d})

        -- back
        table.insert(vertices, {x-w, y-h, z+d})
        table.insert(vertices, {x+w, y-h, z+d})
        table.insert(vertices, {x+w, y+h, z+d})
        table.insert(vertices, {x-w, y-h, z+d})
        table.insert(vertices, {x+w, y+h, z+d})
        table.insert(vertices, {x-w, y+h, z+d})

        -- left
        table.insert(vertices, {x-w, y-h, z+d})
        table.insert(vertices, {x-w, y-h, z-d})
        table.insert(vertices, {x-w, y+h, z-d})
        table.insert(vertices, {x-w, y-h, z+d})
        table.insert(vertices, {x-w, y+h, z-d})
        table.insert(vertices, {x-w, y+h, z+d})        

        -- right
        table.insert(vertices, {x+w, y-h, z+d})
        table.insert(vertices, {x+w, y-h, z-d})
        table.insert(vertices, {x+w, y+h, z-d})
        table.insert(vertices, {x+w, y-h, z+d})
        table.insert(vertices, {x+w, y+h, z-d})
        table.insert(vertices, {x+w, y+h, z+d})

        Graphics.boxMesh = love.graphics.newMesh(format, vertices, 'triangles', 'static')

        local vertexcode = [[
            vec4 position( mat4 transform_projection, vec4 vertex_position )
            {
                return transform_projection * transform_projection * vertex_position;
            }
        ]]

        local pixelcode = [[
            vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
            {
                vec4 texcolor = Texel(tex, texture_coords);
                return  texcolor * color;
            }
        ]]
        Graphics.boxShader = love.graphics.newShader(pixelcode, vertexcode)
    end        

    love.graphics.setShader(Graphics.boxShader)

    pushMatrix()
    do
        translate(x, y, z)
        scale(w, h, d)

        if fill() then
            love.graphics.setColor(fill():unpack())        
            love.graphics.draw(Graphics.boxMesh)
        end
    end
    popMatrix()

    love.graphics.setShader()
end
