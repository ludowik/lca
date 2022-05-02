local love2d = love

local Graphics = class 'GraphicsLove'

function Graphics:init()
    push2_G(Graphics)
    love2d.graphics.setLineStyle('smooth')
end

function Graphics.clip(...)
    love.graphics.setScissor(...)
end

function Graphics.background(clr)
    clr = clr or colors.black
    love.graphics.clear(clr:unpack())
end

function Graphics.blendMode(mode, alphamode)
    if mode then
        _blendMode = mode
        _blendAlphaMode = alphamode

        love.graphics.setBlendMode(mode, alphamode)
    end
    return _blendMode
end

local resources = {}
function Graphics.textRes(txt)
    local font = love2d.graphics.getFont()

    local resName = txt .. Graphics.fontSize()
    local res = resources[resName]
    if not res then
        resources[resName] = {
            text = love2d.graphics.newText(font, txt),
        }
        resources[resName].w, resources[resName].h = resources[resName].text:getDimensions()
        res = resources[resName]
    end

    return res
end

function Graphics.fontSize(size)
    _fontSize = size or _fontSize or 12
    if size then
        love2d.graphics.setNewFont(size)
    end
    return _fontSize
end

function Graphics.textSize(txt)
    local res = Graphics.textRes(txt)
    return res.w, res.h
end

function Graphics.text(txt, x, y)
    if type(txt) == 'table' then
        local t = txt
        txt = ''
        for _,v in ipairs(t) do
            txt = txt .. tostring(v) .. ' '
        end
    else
        txt = tostring(txt)
    end

    local res = Graphics.textRes(txt)    
    local w, h = res.w, res.h

    x = x or 0
    if not y then
        y = textPosition
        textPosition = textPosition + h
    end

    if textMode() == CENTER then
        x = x - w / 2
        y = y - h / 2
    end

    love.graphics.setBlendMode('alpha')
    love2d.graphics.setColor(textColor():unpack())
    love2d.graphics.draw(res.text, x, y)
end

function Graphics.point(x, y)
    love2d.graphics.setColor(stroke():unpack())
    love2d.graphics.setPointSize(strokeSize())
    love2d.graphics.points(x, y)
end

function Graphics.points(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end

    love2d.graphics.setColor(1, 1, 1, 1)
    love2d.graphics.setPointSize(strokeSize())

    local format = {
        {"VertexPosition", "float", 2}, -- The x,y position of each vertex.
        -- {"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
        {"VertexColor", "byte", 4} -- The r,g,b,a color of each vertex.
    }

    local mesh = love2d.graphics.newMesh(format, t, 'points', 'static')
    Graphics.drawMesh(mesh)
end

function Graphics.line(x1, y1, x2, y2)
    love2d.graphics.setColor(stroke():unpack())
    love2d.graphics.setLineWidth(strokeSize())
    love2d.graphics.line(x1, y1, x2, y2)
end

function Graphics.lines(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end

    love2d.graphics.setColor(stroke():unpack())
    love2d.graphics.setLineWidth(strokeSize())    
    for i=1,#t,4 do
        Graphics.line(t[i], t[i+1], t[i+2], t[i+3])
    end
end

function Graphics.polyline(t)
    love2d.graphics.setColor(stroke():unpack())
    love2d.graphics.setLineWidth(strokeSize())
    love2d.graphics.line(t)
end

function Graphics.polygon(t)
    love2d.graphics.setColor(stroke():unpack())
    love2d.graphics.setLineWidth(strokeSize())
    love2d.graphics.polygon('line', t)
end

function Graphics.rect(x, y, w, h)
    if rectMode() == CENTER then
        x = x - w / 2
        y = y - h / 2
    end

    if fill() then
        love2d.graphics.setColor(fill():unpack())
        love2d.graphics.rectangle('fill', x, y, w, h)
    end

    if stroke() then
        love2d.graphics.setColor(stroke():unpack())
        love2d.graphics.setLineWidth(strokeSize())
        love2d.graphics.rectangle('line', x, y, w, h)
    end
end

function Graphics.circle(x, y, r)
    if circleMode() == CORNER then
        x = x - r
        y = y - r
    end

    if fill() then
        love2d.graphics.setColor(fill():unpack())
        love2d.graphics.circle('fill', x, y, r)
    end

    if stroke() then
        love2d.graphics.setColor(stroke():unpack())
        love2d.graphics.setLineWidth(strokeSize())
        love2d.graphics.circle('line', x, y, r)
    end
end

function Graphics.ellipse(x, y, w, h)
    if circleMode() == CORNER then
        x = x - r
        y = y - r
    end

    if fill() then
        love2d.graphics.setColor(fill():unpack())
        love2d.graphics.ellipse('fill', x, y, w/2, h/2)
    end

    if stroke() then
        love2d.graphics.setColor(stroke():unpack())
        love2d.graphics.setLineWidth(strokeSize())
        love2d.graphics.ellipse('line', x, y, w/2, h/2)
    end
end

function Graphics.box(x, y, z, w, h, d)
    GraphicsTemplate.box(x, y, z, w, h, d)
end

function Graphics.drawMesh(mesh)
    love2d.graphics.draw(mesh.mesh or mesh)
end
