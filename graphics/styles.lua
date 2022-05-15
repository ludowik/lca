function resetStyles()
    textPosition = 0
    textColor(colors.white)
    
    stroke(colors.red)
    strokeSize(1)
    
    fill(colors.white)
    
    fontSize(12)
    
    textMode(CORNER)
    rectMode(CORNER)
    circleMode(CENTER)
    spriteMode(CENTER)
end

function blendMode(mode, alphamode)
    if mode then
        _blendMode = mode
        _blendAlphaMode = alphamode

        love.graphics.setBlendMode(mode, alphamode)
    end
    return _blendMode
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

function spriteMode(mode)
    _spriteMode = mode or _spriteMode or CENTER
    return _spriteMode
end

function textColor(clr, ...)
    if type(clr) == 'number' then clr = Color(clr, ...) end
    _textColor = clr or _textColor or colors.white
    return _textColor
end

function noStroke()
    _strokeColor = nil
end

function stroke(clr, ...)
    if type(clr) == 'number' then clr = Color(clr, ...) end
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

function fill(clr, ...)
    if type(clr) == 'number' then clr = Color(clr, ...) end
    _fillColor = clr or _fillColor
    return _fillColor
end
