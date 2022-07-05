local Graphics = class 'GraphicsCore' : extends(GraphicsBase)

function Graphics:init()
    push2_G(Graphics)
end

function Graphics.point(x, y)
    if type(x) == 'table' then x, y = x.x, x.y end

    Graphics.rect(
        x - strokeSize() * .5,
        y - strokeSize() * .5,
        strokeSize(),
        strokeSize(), {
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
    if not stroke() then return end

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

    Graphics.lineMesh = Graphics.newMesh(vertices, 'triangles', 'static')
    love.graphics.setColor(stroke():unpack())        
    Graphics.drawMesh(Graphics.lineMesh)
end

function Graphics.lines(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end

    love.graphics.setColor(stroke():unpack())
    for i=1,#t,4 do
        Graphics.line(t[i], t[i+1], t[i+2], t[i+3])
    end
end

function Graphics.polyline(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end
    Graphics.polyline_(t)
end

function Graphics.polyline_(t, x, y, w, h)
    x, y, w, h = x or 0, y or 0, w or 1, h or 1

    love.graphics.setColor(stroke():unpack())

    local vertices = {}
    local x1, y1 = x+w*t[1], y+h*t[2]
    for i=3,#t,2 do
        local x2, y2 = x+w*t[i], y+h*t[i+1]

        local v = vec2(x2, y2) - vec2(x1, y1)
        v = v:normalize(strokeSize()*0.5)
        v.x, v.y = -v.y, v.x

        do
            table.insert(vertices, {x1-v.x, y1-v.y, 0, 0})
            table.insert(vertices, {x2-v.x, y2-v.y, 0, 0})
            table.insert(vertices, {x2+v.x, y2+v.y, 0, 0})
            table.insert(vertices, {x1-v.x, y1-v.y, 0, 0})
            table.insert(vertices, {x2+v.x, y2+v.y, 0, 0})
            table.insert(vertices, {x1+v.x, y1+v.y, 0, 0})
        end

        x1, y1 = x2, y2
    end

    Graphics.polylineMesh = Graphics.newMesh(vertices, 'triangles', 'static')
    love.graphics.setColor(stroke():unpack())        
    Graphics.drawMesh(Graphics.polylineMesh)
end

function Graphics.polygon(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end

    love.graphics.setColor(stroke():unpack())

    local x, y = t[1], t[2]
    for i=3,#t,2 do
        Graphics.line(x, y, t[i], t[i+1])
        x, y = t[i], t[i+1]
    end
    Graphics.line(x, y, t[1], t[2])
end

function Graphics.rect(x, y, w, h)
    Graphics.rect_(x, y, w, h)
end

function Graphics.rect_(x, y, w, h, attr)
    h = h or w

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
        Graphics.rectMesh = Graphics.newMesh(vertices, 'triangles', 'static')
    end        

    pushMatrix()
    do
        translate(x, y)
        scale(w, h)

        local _fillColor = attr and attr._fillColor or fill()
        if _fillColor then
            love.graphics.setColor(_fillColor:unpack())
            Graphics.drawMesh(Graphics.rectMesh)
        end
    end
    popMatrix()
end

function Graphics.circle(x, y, radius)
    if circleMode() == CORNER then
        x = x - radius
        y = y - radius
    end

    if not Graphics.circleMesh then
        local vertices, border = {}, {}
        local x, y, w, h = 0, 0, 1, 1 
        local nstep = 32
        table.insert(vertices, {x, y, 0, 0})
        for step = 0, nstep do
            local angle = TAU * step / nstep
            table.insert(vertices, {x+cos(angle), y+sin(angle), cos(angle), sin(angle)})
            table.insert(border, x+cos(angle))
            table.insert(border, y+sin(angle))
        end
        Graphics.circleMesh = Graphics.newMesh(vertices, 'fan', 'static')
        Graphics.circleBorderMesh = border
    end

    pushMatrix()
    do
        translate(x, y)
        scale(radius, radius)

        if fill() then
            love.graphics.setColor(fill():unpack())        
            Graphics.drawMesh(Graphics.circleMesh)
        end
    end
    popMatrix()

    if stroke() then
        polyline_(Graphics.circleBorderMesh, x, y, radius, radius)
    end
end

function Graphics.ellipse(x, y, w, h)
    h = h or w

    if ellipseMode() == CORNER then
        x = x - w/2
        y = y - h/2
    end

    if not Graphics.ellipseMesh then
        local vertices, border = {}, {}
        local x, y, w, h = 0, 0, 1, 1 
        local nstep = 32
        table.insert(vertices, {x, y, 0, 0})
        for step = 0, nstep do
            local angle = TAU * step / nstep
            table.insert(vertices, {x+cos(angle), y+sin(angle), cos(angle), sin(angle)})
            table.insert(border, x+cos(angle))
            table.insert(border, y+sin(angle))
        end
        Graphics.ellipseMesh = Graphics.newMesh(vertices, 'fan', 'static')
        Graphics.circleBorderMesh = border
    end

    pushMatrix()
    do
        translate(x, y)
        scale(w/2, h/2)

        if fill() then
            love.graphics.setColor(fill():unpack())        
            Graphics.drawMesh(Graphics.ellipseMesh)
        end
    end
    popMatrix()

    if stroke() then
        polyline_(Graphics.circleBorderMesh, x, y, w/2, h/2)
    end
end

shaders = {}
function Graphics.createShader()
    if Graphics.shader3D then return end

    local vertexcode = [[
            uniform mat4 pvm;
            vec4 position( mat4 transform_projection, vec4 vertex_position )
            {
                // return transform_projection * vertex_position;
                return pvm * vertex_position;
            }
        ]]

    local pixelcode = [[
            vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
            {
                vec4 texcolor = Texel(tex, texture_coords);
                return texcolor * color;
            }
        ]]
    Graphics.shader3D = love.graphics.newShader(pixelcode, vertexcode)

    shaders['shader3D'] = Graphics.shader3D
end

function Model_setColors(colors, clr)
    for i=#colors-5,#colors do
        colors[i][4+2] = clr.r
        colors[i][5+2] = clr.g
        colors[i][6+2] = clr.b
        colors[i][7+2] = clr.a
    end
end

function Model_box(x, y, z, w, h, d)
    x, y, z, w, h, d = x or 0, y or 0, z or 0, w or 1, h or 1, d or 1

    local vertices = {}

    -- front
    table.insert(vertices, {x-w, y-h, z-d, 0, 0})
    table.insert(vertices, {x+w, y-h, z-d, 0, 0})
    table.insert(vertices, {x+w, y+h, z-d, 0, 0})
    table.insert(vertices, {x-w, y-h, z-d, 0, 0})
    table.insert(vertices, {x+w, y+h, z-d, 0, 0})
    table.insert(vertices, {x-w, y+h, z-d, 0, 0})
    Model_setColors(vertices, colors.green)

    -- back
    table.insert(vertices, {x+w, y-h, z+d, 0, 0})
    table.insert(vertices, {x-w, y-h, z+d, 0, 0})
    table.insert(vertices, {x-w, y+h, z+d, 0, 0})
    table.insert(vertices, {x+w, y-h, z+d, 0, 0})
    table.insert(vertices, {x-w, y+h, z+d, 0, 0})
    table.insert(vertices, {x+w, y+h, z+d, 0, 0})
    Model_setColors(vertices, colors.yellow)

    -- left
    table.insert(vertices, {x-w, y-h, z+d, 0, 0})
    table.insert(vertices, {x-w, y-h, z-d, 0, 0})
    table.insert(vertices, {x-w, y+h, z-d, 0, 0})
    table.insert(vertices, {x-w, y-h, z+d, 0, 0})
    table.insert(vertices, {x-w, y+h, z-d, 0, 0})
    table.insert(vertices, {x-w, y+h, z+d, 0, 0})
    Model_setColors(vertices, colors.orange)

    -- right
    table.insert(vertices, {x+w, y-h, z-d, 0, 0})
    table.insert(vertices, {x+w, y-h, z+d, 0, 0})
    table.insert(vertices, {x+w, y+h, z+d, 0, 0})
    table.insert(vertices, {x+w, y-h, z-d, 0, 0})
    table.insert(vertices, {x+w, y+h, z+d, 0, 0})
    table.insert(vertices, {x+w, y+h, z-d, 0, 0})
    Model_setColors(vertices, colors.red)

    -- up
    table.insert(vertices, {x-w, y+h, z-d, 0, 0})
    table.insert(vertices, {x+w, y+h, z-d, 0, 0})
    table.insert(vertices, {x+w, y+h, z+d, 0, 0})
    table.insert(vertices, {x-w, y+h, z-d, 0, 0})
    table.insert(vertices, {x+w, y+h, z+d, 0, 0})
    table.insert(vertices, {x-w, y+h, z+d, 0, 0})
    Model_setColors(vertices, colors.white)

    -- down
    table.insert(vertices, {x+w, y-h, z-d, 0, 0})
    table.insert(vertices, {x-w, y-h, z-d, 0, 0})
    table.insert(vertices, {x-w, y-h, z+d, 0, 0})
    table.insert(vertices, {x+w, y-h, z-d, 0, 0})
    table.insert(vertices, {x-w, y-h, z+d, 0, 0})
    table.insert(vertices, {x+w, y-h, z+d, 0, 0})
    Model_setColors(vertices, colors.blue)

    return vertices
end

function Graphics.drawModel(mesh, x, y, z, w, h, d)
    Graphics.createShader()

    local shader = love.graphics.getShader()
    love.graphics.setShader(Graphics.shader3D)

    pushMatrix()
    do
        if x then
            translate(x, y, z)
        end

        if w then
            scale(w, h, d)
        end

        if fill() then
            Graphics.shader3D:send('pvm', {
                    pvmMatrix():getMatrix()
                })

            love.graphics.setColor(fill():unpack())        
            Graphics.drawMesh(mesh)
        end
    end
    popMatrix()

    love.graphics.setShader(shader)
end

function Graphics.box(x, y, z, w, h, d)
    if not Graphics.boxMesh then
        local x, y, z, w, h, d = 0, 0, 0, 0.5, 0.5, 0.5
        local format = {
            {"VertexPosition", "float", 3}, -- The x,y position of each vertex.
            {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
            {"VertexColor", "byte", 4} -- The r,g,b,a color of each vertex.
        }

        local m = Model.box(x, y, z, w, h, d)

        -- front
        m:setRectColor(1, colors.green)

        -- back
        m:setRectColor(7, colors.yellow)

        -- left
        m:setRectColor(13, colors.orange)

        -- right
        m:setRectColor(19, colors.red)

        -- up
        m:setRectColor(25, colors.white)

        -- down
        m:setRectColor(31, colors.blue)

        Graphics.boxMesh = m -- Graphics.newMesh(format, m.vertices, 'triangles', 'static')
    end

    Graphics.drawModel(Graphics.boxMesh, x, y, z, w, h, d)
end

function Graphics.sphere(x, y, z, r)
    if not Graphics.sphereMesh then
        local x, y, z, w, h, d = 0, 0, 0, 0.5, 0.5, 0.5
        local format = {
            {"VertexPosition", "float", 3}, -- The x,y position of each vertex.
            {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
            {"VertexColor", "byte", 4} -- The r,g,b,a color of each vertex.
        }

        local m = Model.sphere(x, y, z, w, h, d)
        Graphics.sphereMesh = m -- Graphics.newMesh(format, m.vertices, 'triangles', 'static')
    end

    Graphics.drawModel(Graphics.sphereMesh, x, y, z, w, h, d)
end

function Graphics.newMesh(...)
    local args = {...}
    local mesh = {
        mesh = love.graphics.newMesh(...)
    }

    if #args == 3 then
        mesh.vertices = args[1]
    elseif #args == 4 then
        mesh.vertices = args[2]
    end
    return mesh
end

function Graphics.drawMesh(mesh)
    if mesh.mesh then
        love.graphics.draw(mesh.mesh)
    else
        mesh:draw()
    end
end
