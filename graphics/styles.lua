local styles

function resetStyles()
    styles = table()
    
    textPosition = 0
    textColor(colors.white)

    stroke(colors.red)
    strokeSize(1)

    fill(colors.white)

    fontName(DEFAULT_FONT_NAME)
    fontSize(12)

    textMode(CORNER)
    rectMode(CORNER)
    circleMode(CENTER)
    spriteMode(CENTER)

    depthMode(false)
end

function pushStyle()
    push('styles', styles:clone())
end

function popStyle()
    styles = pop('styles')
end

NORMAL = 'alpha'
ADDITIVE = 'add'
MULTIPLY = 'multiply'

-- alphamultiply
-- premultiplied

function blendMode(mode, alphamode)
    if mode then
        styles._blendMode = mode
        styles._blendAlphaMode = alphamode

        love.graphics.setBlendMode(mode,
            mode == MULTIPLY and 'premultiplied' or alphamode)
    end
    return styles._blendMode
end

CORNER = 'corner'
CENTER = 'center'

function textMode(mode)
    styles._textMode = mode or styles._textMode or CORNER
    return styles._textMode
end

function rectMode(mode)
    styles._rectMode = mode or styles._rectMode or CORNER
    return styles._rectMode
end

function circleMode(mode)
    styles._circleMode = mode or styles._circleMode or CENTER
    return styles._circleMode
end

function ellipseMode(mode)
    styles._ellipseMode = mode or styles._ellipseMode or CENTER
    return styles._ellipseMode
end

function spriteMode(mode)
    styles._spriteMode = mode or styles._spriteMode or CENTER
    return styles._spriteMode
end

function textColor(clr, ...)
    if type(clr) == 'number' then clr = Color(clr, ...) end
    
    styles._textColor = clr or styles._textColor or colors.white
    return styles._textColor
end

function noStroke()
    _strokeColor = nil
end

function stroke(clr, ...)
    if type(clr) == 'number' then clr = Color(clr, ...) end
    
    styles._strokeColor = clr or styles._strokeColor
    return styles._strokeColor
end

function strokeSize(size)
    styles._strokeSize = size or styles._strokeSize or 1
    return styles._strokeSize
end

function noFill()
    styles._fillColor = nil
end

function fill(clr, ...)
    if type(clr) == 'number' then clr = Color(clr, ...) end
    
    styles._fillColor = clr or styles._fillColor
    return styles._fillColor
end

function depthMode(mode)
    if mode ~= nil then
        styles._depthMode = mode 

        if styles._depthMode then
            love.graphics.setDepthMode('lequal', true)
        else
            love.graphics.setDepthMode('always', false)
        end
    end
    return styles._depthMode
end

function cullingMode(mode)
    if mode ~= nil then
        styles._cullingMode = mode

        if styles._cullingMode then
            love.graphics.setMeshCullMode('back')
            love.graphics.setFrontFaceWinding('ccw')
        else
            love.graphics.setMeshCullMode('none')
        end
    end
    return styles._cullingMode
end

function light()
    -- TODO
end

function loop()
    env.__loop = nil
end

function noLoop()
    env.__loop = 0
end

function redraw()
    env.__loop = 1
end

function tint()
    -- TODO
end

function noTint()
    -- TODO
end
