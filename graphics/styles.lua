function resetStyles()
    rectMode(CORNER)
    circleMode(CENTER)
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

function fill(clr)
    _fillColor = clr or _fillColor or colors.white
    return _fillColor
end
