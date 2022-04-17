function point(x, y)
    love.graphics.points(x, y)
end

function points(...)
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
end

function circle(x, y, r)
    if circleMode() == CORNER then
        x = x - r
        y = y - r
    end
    love.graphics.circle('fill', x, y, r)
end
