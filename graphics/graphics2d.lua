function textSize(txt)
    local font = love.graphics.getFont()
    return font:getHeight() * #txt, font:getHeight()
--    return font:getWidth(txt), font:getHeight()
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
    
    local w, h = textSize(txt)

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
    love.graphics.print(txt, x, y)    
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
