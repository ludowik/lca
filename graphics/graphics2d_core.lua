local Graphics = class 'GraphicsCore' : extends(GraphicsBase)

function Graphics:init()
    push2_G(Graphics)
    love.graphics.setLineStyle('smooth')    
end

function Graphics.point(x, y)
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
    love.graphics.setLineWidth(strokeSize())    
    for i=1,#t,4 do
        Graphics.line(t[i], t[i+1], t[i+2], t[i+3])
    end
end

function Graphics.polyline(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end

    love.graphics.setColor(stroke():unpack())
    love.graphics.setLineWidth(strokeSize())

    local vertices = {}
    local x1, y1 = t[1], t[2]
    for i=3,#t,2 do
        local x2, y2 = t[i], t[i+1]

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

--        Graphics.line(x, y, t[i], t[i+1])
        x1, y1 = x2, y2
    end

    Graphics.polylineMesh = Graphics.newMesh(vertices, 'triangles', 'static')
    love.graphics.setColor(stroke():unpack())        
    Graphics.drawMesh(Graphics.polylineMesh)
end

function Graphics.polygon(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end

    love.graphics.setColor(stroke():unpack())
    love.graphics.setLineWidth(strokeSize())    
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
        x = x - w/2
        y = y - h/2
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
        Graphics.circleMesh = Graphics.newMesh(vertices, 'fan', 'static')
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
end

function Graphics.ellipse(x, y, w, h)
    if ellipseMode() == CORNER then
        x = x - w/2
        y = y - h/2
    end

    if not Graphics.ellipseMesh then
        local vertices = {}
        local x, y, w, h = 0, 0, 1, 1 
        local nstep = 32
        table.insert(vertices, {x, y, 0, 0})
        for step = 0, nstep do
            local angle = TAU * step / nstep
            table.insert(vertices, {x+cos(angle), y+sin(angle), cos(angle), sin(angle)})
        end
        Graphics.ellipseMesh = Graphics.newMesh(vertices, 'fan', 'static')
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
                // vec4 texcolor = Texel(tex, texture_coords);
                return /*texcolor * */ color;
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

function Graphics.box(x, y, z, w, h, d)
    Graphics.createShader()
    
    if not Graphics.boxMesh then
        local x, y, z, w, h, d = 0, 0, 0, 0.5, 0.5, 0.5
        local format = {
            {"VertexPosition", "float", 3}, -- The x,y position of each vertex.
            {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
            {"VertexColor", "byte", 4} -- The r,g,b,a color of each vertex.
        }

        local vertices = Model_box(x, y, z, w, h, d)
        Graphics.boxMesh = Graphics.newMesh(format, vertices, 'triangles', 'static')
    end

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
            Graphics.drawMesh(Graphics.boxMesh)
        end
    end
    popMatrix()

    love.graphics.setShader()
end

function Graphics.sphere(x, y, z, r)
    Graphics.createShader()
    
    if not Graphics.sphereMesh then
        local x, y, z, w, h, d = 0, 0, 0, 0.5, 0.5, 0.5
        local format = {
            {"VertexPosition", "float", 3}, -- The x,y position of each vertex.
            {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
            {"VertexColor", "byte", 4} -- The r,g,b,a color of each vertex.
        }

        local vertices = Model_box(x, y, z, w, h, d)
        Graphics.sphereMesh = Graphics.newMesh(format, vertices, 'triangles', 'static')
    end

    love.graphics.setShader(Graphics.shader3D)

    pushMatrix()
    do
        if x then
            translate(x, y, z)
        end

        if r then
            scale(r)
        end

        if fill() then
            Graphics.shader3D:send('pvm', {
                    pvmMatrix():getMatrix()
                })

            love.graphics.setColor(fill():unpack())        
            Graphics.drawMesh(Graphics.sphereMesh)
        end
    end
    popMatrix()

    love.graphics.setShader()
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
    love.graphics.draw(mesh.mesh or mesh)
end

-- pipeline 3d
local function edgeFunction(a, b, c)
    return (c.x - a.x) * (b.y - a.y) - (c.y - a.y) * (b.x - a.x)
end

Graphics.drawMesh_ = Graphics.drawMesh or function (mesh)
    _G.env.imageData = _G.env.imageData or love.image.newImageData(W, H)

    local vertices = table()

    -- Vertex shader
    local xmin, ymin, xmax, ymax = W, H, 0, 0
    for t = 1, #mesh.vertices do
        local v = mesh.vertices[t]
        v = vertexShader(vec3(v[1], v[2], v[3]))

        vertices:insert(v)

        xmin = min(xmin, v.x)
        xmax = max(xmax, v.x)

        ymin = min(ymin, v.y)
        ymax = max(ymax, v.y)
    end

    xmin = max(0, floor(xmin))
    ymin = max(0, floor(ymin))

    xmax = min(W, ceil(xmax))
    ymax = min(H, ceil(ymax))

    -- assemblage des primitives
    if #vertices % 3 ~= 0 then
        return
    end

    -- rasterisation
    for y = ymin, ymax do
        for x = xmin, xmax do
            local p = vec2(x + 0.5, y + 0.5)

            for t = 1, #vertices / 3 do
                local offset = (t - 1) * 3
                local v0, v1, v2 = vertices[offset + 1], vertices[offset + 2], vertices[offset + 3]

                --                local clr = Color(v0[6], v0[7], v0[8]) -- mesh.colors[1]

                --                local c0 = Color(v0[6], v0[7], v0[8]) -- mesh.colors[offset + 1] or clr
                --                local c1 = Color(v1[6], v1[7], v1[8]) -- mesh.colors[offset + 2] or clr
                --                local c2 = Color(v2[6], v2[7], v2[8]) -- mesh.colors[offset + 3] or clr
                local c0, c1, c2 = colors.red, colors.green, colors.blue

                local area = edgeFunction(v0, v1, v2)

                local w0 = edgeFunction(v1, v2, p)
                local w1 = edgeFunction(v2, v0, p)
                local w2 = edgeFunction(v0, v1, p)

                if ((w0 >= 0 and w1 >= 0 and w2 >= 0) or (w0 <= 0 and w1 <= 0 and w2 <= 0)) then
                    w0 = w0 / area
                    w1 = w1 / area
                    w2 = w2 / area

                    local r = w0 * c0.r + w1 * c1.r + w2 * c2.r
                    local g = w0 * c0.g + w1 * c1.g + w2 * c2.g
                    local b = w0 * c0.b + w1 * c1.b + w2 * c2.b

                    local z = w0 * v0.z + w1 * v1.z + w2 * v2.z

                    -- Fragment shader
                    fragmentShader(x, y, z, Color(r, g, b, 1))
                end
            end
        end
    end
end

-- shaders
local function keepsafe(v)
    if v > 255 then
        return 255
    elseif v < 0 then
        return 0
    end
    return v
end

function vertexShader(vt)
    local pv = pvMatrix()
    local m = modelMatrix()
    --    local v = (pv*m):mulVector(vt)
    local v = matByVector((pv*m), vt)
    --    v = v / v.w
    return v -- vec3((v.x + 1) * W / 2, (v.y + 1) * H / 2, v.z)
end

function fragmentShader(x, y, z, clr)
    local r, g, b, a = clr.r, clr.g, clr.b, clr.a

    local _blendMode = blendMode()

    if x >= 0 and x <= W - 1 and y >= 0 and y <= H - 1 then
        if usePtr then
            x, y = floor(x), floor(y)

            local offset = (x + y * W) * 4

            if context.depths and context.depths[offset] and context.depths[offset] < z then
                return
            end
            context.depths[offset] = z

            context.ptrr[offset] = keepsafe(_blendMode(r * 255, context.ptrr[offset], a))
            context.ptrg[offset] = keepsafe(_blendMode(g * 255, context.ptrg[offset], a))
            context.ptrb[offset] = keepsafe(_blendMode(b * 255, context.ptrb[offset], a))
            context.ptra[offset] = keepsafe(_blendMode(a * 255, context.ptra[offset], a))
        else
            _G.env.imageData:setPixel(x, y, r, g, b, a)
        end
    end
end
