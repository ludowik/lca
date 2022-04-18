function resetStyles()
    textPosition = 0
    textColor(white)
    
    stroke(white)
    strokeSize(1)
    
    fill(gray)
    
    rectMode(CORNER)
    circleMode(CENTER)
    
    love.graphics.setLineStyle('smooth')
end

CORNER = 'corner'
CENTER = 'center'

function rectMode(mode)
    _rectMode = mode or _rectMode or CORNER
    return _rectMode
end

function circleMode(mode)
    _circleMode = mode or _circleMode or CENTER
    return _circleMode
end

function textColor(clr)
    _textColor = clr or _textColor or colors.white
    return _textColor
end

function stroke(clr)
    _strokeColor = clr or _strokeColor or colors.white
    return _strokeColor
end

function strokeSize(size)
    _strokeSize = size or _strokeSize or 1
    return _strokeSize
end

function fill(clr)
    _fillColor = clr or _fillColor or colors.gray
    return _fillColor
end
