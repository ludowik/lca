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
    love.graphics.clear(clr:unpack())
end

local resources = {}
function Graphics.textRes(txt)
    local font = love2d.graphics.getFont()

    local resName = txt .. Graphics.fontSize()
    local res = resources[resName]
    if not res then
        resources[resName] = {
            text = love2d.graphics.newText(font, txt),
            w = font:getWidth(txt),
            h = font:getHeight(),
        }
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

    love2d.graphics.setColor(textColor():unpack())
    love2d.graphics.draw(res.text, x, y)
end

function Graphics.point(x, y)
    love2d.graphics.setColor(stroke():unpack())
    love2d.graphics.setPointSize(strokeSize())
    love2d.graphics.points(x, y)
end

function Graphics.points(...)
    love2d.graphics.setColor(stroke():unpack())
    love2d.graphics.setPointSize(strokeSize())
    love2d.graphics.points(...)
end

function Graphics.line(x1, y1, x2, y2)
    love2d.graphics.setColor(stroke():unpack())
    love2d.graphics.setLineWidth(strokeSize())
    love2d.graphics.line(x1, y1, x2, y2)
end

function Graphics.lines(t)
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

    if stroke() then    love2d.graphics.setColor(stroke():unpack())
        love2d.graphics.setLineWidth(strokeSize())
        love2d.graphics.circle('line', x, y, r)
    end
end
