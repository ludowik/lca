-- www.scratchapixel.com
local min, max, floor, ceil, cos, sin = math.min, math.max, math.floor, math.ceil, math.cos, math.sin

local context
usePtr = true

function image(w, h)
    local context = {}

    context.data = love.image.newImageData(w, h)

    context.ptr = ffi.cast('uint8_t*', context.data:getFFIPointer())
    assert(context.ptr)

    context.ptrr = context.ptr + 0
    context.ptrg = context.ptr + 1
    context.ptrb = context.ptr + 2
    context.ptra = context.ptr + 3

    context.depths = {}

    return context
end

function beginDraw()
    context = context or image(W, H)
    context.depths = {}

    blendMode(REPLACE)
    pointSize(3)

    return context
end

function endDraw()
    love.graphics.draw(love.graphics.newImage(context.data), 0, pixelSize * H, 0, pixelSize, -pixelSize)
end

function background(...)
    local clr = Color.tocolor(...) or colors.black
    local r, b, g, a = clr:tocomposants()

    local _blendMode = blendMode()

    local offset = 0
    for y = 0, H - 1 do
        for x = 0, W - 1 do
            context.ptrr[offset] = _blendMode(r * 255, context.ptrr[offset], a)
            context.ptrg[offset] = _blendMode(g * 255, context.ptrg[offset], a)
            context.ptrb[offset] = _blendMode(b * 255, context.ptrb[offset], a)
            context.ptra[offset] = _blendMode(a * 255, context.ptra[offset], a)
            offset = offset + 4
        end
    end
end

local function edgeFunction(a, b, c)
    return (c.x - a.x) * (b.y - a.y) - (c.y - a.y) * (b.x - a.x)
end

-- pipeline 3d
function drawMesh(mesh)
    local vertices = table()
    
    -- Vertex shader
    local xmin, ymin, xmax, ymax = W, H, 0, 0
    for t = 1, #mesh.vertices do
        local v = mesh.vertices[t]
        v = vertexShader(v)
        
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
            local p = Vec2(x + 0.5, y + 0.5)

            for t = 1, #vertices / 3 do
                local offset = (t - 1) * 3
                local v0, v1, v2 = vertices[offset + 1], vertices[offset + 2], vertices[offset + 3]

                local clr = mesh.colors[1]

                local c0 = mesh.colors[offset + 1] or clr
                local c1 = mesh.colors[offset + 2] or clr
                local c2 = mesh.colors[offset + 3] or clr

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

function drawMesh(mesh)
    -- Vertex shader
    local xmin, ymin, xmax, ymax = W, H, 0, 0
    for t = 1, #mesh.vertices do
        local v = mesh.vertices[t]
        v.x, v.y, v.z = vertexShader(v) -- x, v.y, v.z)

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
    if #mesh.vertices % 3 ~= 0 then
        return
    end
end

function rasterTriangle_()
    function drawLine(x1, y1, x2, y2)
        for x = x1, x2 do
            fragmentShader(x, y, 1, colors.white)
        end
    end

    function fillBottomFlatTriangle(v1, v2, v3)
        invslope1 = (v2.x - v1.x) / (v2.y - v1.y);
        invslope2 = (v3.x - v1.x) / (v3.y - v1.y);

        curx1 = v1.x;
        curx2 = v1.x;

        for scanlineY = v1.y, v2.y - 1 do
            drawLine(curx1, scanlineY, curx2, scanlineY);
            curx1 = curx1 + invslope1;
            curx2 = curx2 + invslope2;
        end
    end

    function fillTopFlatTriangle(v1, v2, v3)
        invslope1 = (v3.x - v1.x) / (v3.y - v1.y);
        invslope2 = (v3.x - v2.x) / (v3.y - v2.y);

        curx1 = v3.x;
        curx2 = v3.x;

        for scanlineY = v3.y, v1.y + 1, -1 do
            drawLine(curx1, scanlineY, curx2, scanlineY);
            curx1 = curx1 - invslope1;
            curx2 = curx2 - invslope2;
        end
    end

    -- at first sort the three vertices by y-coordinate ascending so v1 is the topmost vertice
    sortVerticesAscendingByY();

    -- here we know that v1.y <= v2.y <= v3.y
    -- check for trivial case of bottom-flat triangle
    if (v2.y == v3.y) then
        fillBottomFlatTriangle(v1, v2, v3);

        -- check for trivial case of top-flat triangle
    elseif (vt1.y == vt2.y) then
        fillTopFlatTriangle(g, vt1, vt2, vt3);
    else
        -- general case - split the triangle in a topflat and bottom-flat one
        v4 = vec4((int)(vt1.x + ((float)(vt2.y - vt1.y) / (float)(vt3.y - vt1.y)) * (vt3.x - vt1.x)), vt2.y);

        fillBottomFlatTriangle(g, vt1, vt2, v4);
        fillTopFlatTriangle(g, vt2, v4, vt3);
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
    local v = (pv*m):mulVector(vt)
    v = v / v.w
    return (v.x + 1) * W / 2, (v.y + 1) * H / 2, v.z
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
            context.data:setPixel(x, y, r, g, b, a)
        end
    end
end
