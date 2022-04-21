function resetStyles()
    textPosition = 0
    textColor(colors.white)
    
    stroke(colors.white)
    strokeSize(1)
    
    fill(colors.gray)
    
    fontSize(12)
    
    textMode(CORNER)
    rectMode(CORNER)
    circleMode(CENTER)
end

CORNER = 'corner'
CENTER = 'center'

function textMode(mode)
    _textMode = mode or _textMode or CORNER
    return _textMode
end

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

function noStroke()
    _strokeColor = nil
end

function stroke(clr)
    _strokeColor = clr or _strokeColor
    return _strokeColor
end

function strokeSize(size)
    _strokeSize = size or _strokeSize or 1
    return _strokeSize
end

function noFill()
    _fillColor = nil
end

function fill(clr)
    _fillColor = clr or _fillColor
    return _fillColor
end
