local resources = {}
function textRes(txt)
    local font = love.graphics.getFont()

    local resName = txt..fontSize()
    local res = resources[resName]
    if not res then
        print('create res '..resName)
        resources[resName] = {
            text = love.graphics.newText(font, txt),
            w = font:getWidth(txt),
            h = font:getHeight(),
        }
        res = resources[resName]
    end

    return res
end

function fontSize(size)
    _fontSize = size or _fontSize or 12
    if size then
        love.graphics.setNewFont(size)
    end
    return _fontSize
end

function textSize(txt)
    local res = textRes(txt)
    return res.w, res.h
end

function text(txt, x, y)
    if type(txt) == 'table' then
        local t = txt
        txt = ''
        for _,v in ipairs(t) do
            txt = txt .. tostring(v) .. ' '
        end
    else
        txt = tostring(txt)
    end

    local res = textRes(txt)    
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

    love.graphics.setColor(textColor():unpack())
    love.graphics.draw(res.text, x, y)
end

function point(x, y)
    love.graphics.setColor(stroke():unpack())
    love.graphics.points(x, y)
end

function points(...)
    love.graphics.setColor(stroke():unpack())
    love.graphics.points(...)
end

function line()
end

function lines()
end

function rect(x, y, w, h)
    if rectMode() == CENTER then
        x = x - w / 2
        y = y - h / 2
    end

    love.graphics.setColor(fill():unpack())    
    love.graphics.rectangle('fill', x, y, w, h)

    love.graphics.setColor(stroke():unpack())    
    love.graphics.setLineWidth(strokeSize())
    love.graphics.rectangle('line', x, y, w, h)
end

function circle(x, y, r)
    if circleMode() == CORNER then
        x = x - r
        y = y - r
    end

    love.graphics.setColor(fill():unpack())
    love.graphics.circle('fill', x, y, r)
end
