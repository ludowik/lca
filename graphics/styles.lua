local styles

function resetStyle()
    styles = table()

    textPosition(0)
    textColor(colors.white)

    stroke(colors.white)
    strokeSize(1)

    fill(colors.white)

    fontName(DEFAULT_FONT_NAME)
    fontSize(12)

    textMode(CORNER)
    rectMode(CORNER)
    circleMode(CENTER)
    spriteMode(CENTER)

    depthMode(false)
    
    blendMode(REPLACE)
end

function pushStyle()
    push('styles', styles:clone())
end

function popStyle()
    styles = pop('styles')
end

s0 = 0.01
s1 = 1.01
for i = 2, 20 do
    _G['s'..i] = i
end

function style(size, clr1, clr2)
    assert(size)

    strokeSize(size)
    if clr1 and clr1 ~= transparent then
        stroke(clr1)
    else
        noStroke()
    end

    if clr2 and clr2 ~= transparent then
        fill(clr2)
    else
        noFill()
    end
end

function textStyle(size, clr, mode)
    assert(size)

    fontSize(size)
    if clr and clr ~= transparent then
        fill(clr)
    else
        noFill()
    end
    textMode(mode)
end

REPLACE = 'replace'
NORMAL = 'alpha'
ADDITIVE = 'add'
MULTIPLY = 'multiply'

-- alphamultiply
-- premultiplied

function blendMode(mode, alphamode)
    if mode then
        styles.blendMode = mode
        styles.blendAlphaMode = alphamode

        love.graphics.setBlendMode(mode,
            mode == MULTIPLY and 'premultiplied' or alphamode)
    end
    return styles.blendMode
end

CORNER = 'corner'
CENTER = 'center'

LEFT = 'left'

class 'Fonts'

function Fonts.getFont(name, size)
    local fontRef = name..'.'..size
    if not Fonts[fontRef] then
        Fonts[fontRef] = love.graphics.newFont(getFontPath() ..'/'.. name .. '.ttf', size)
    end
    return Fonts[fontRef]
end

function fontName(name)
    styles.fontName = name or styles.fontName or DEFAULT_FONT_NAME
    if name then
        love.graphics.setFont(Fonts.getFont(styles.fontName, fontSize()))
    end
    return styles.fontName
end

function fontSize(size)
    styles.fontSize = size or styles.fontSize or 12
    if size then
        love.graphics.setFont(Fonts.getFont(fontName(), styles.fontSize))
    end
    return styles.fontSize
end

function textMode(mode)
    styles.textMode = mode or styles.textMode or CORNER
    return styles.textMode
end

function textAlign(alignMode)
    styles.alignMode = alignMode or styles.alignMode or LEFT
    return styles.alignMode
end

function textWrapWidth(wrapWidth)
    styles.wrapWidth = wrapWidth or 1
    return styles.wrapWidth
end

function textPosition(pos)
    styles.textPosition = pos or styles.textPosition or 0
    return styles.textPosition
end

ROUND = 0
SQUARE = 1
PROJECT = 2

function lineCapMode(mode)
    styles.lineCapMode = mode or styles.lineCapMode or ROUND
    return styles.lineCapMode
end

function rectMode(mode)
    styles.rectMode = mode or styles.rectMode or CORNER
    return styles.rectMode
end

function circleMode(mode)
    styles.circleMode = mode or styles.circleMode or CENTER
    return styles.circleMode
end

function ellipseMode(mode)
    styles.ellipseMode = mode or styles.ellipseMode or CENTER
    return styles.ellipseMode
end

function spriteMode(mode)
    styles.spriteMode = mode or styles.spriteMode or CENTER
    return styles.spriteMode
end

function textColor(clr, ...)
    if type(clr) == 'number' then clr = Color(clr, ...) end

    styles.textColor = clr or styles.textColor or colors.white
    return styles.textColor
end

function noStroke()
    styles.strokeColor = nil
end

function stroke(clr, ...)
    if type(clr) == 'number' then clr = Color(clr, ...) end

    styles.strokeColor = clr or styles.strokeColor
    return styles.strokeColor
end

function strokeSize(size)
    styles.strokeSize = size or styles.strokeSize or 1
    return styles.strokeSize
end

function noFill()
    styles.fillColor = nil
end

function fill(clr, ...)
    if type(clr) == 'number' then clr = Color(clr, ...) end

    styles.fillColor = clr or styles.fillColor
    return styles.fillColor
end

function depthMode(mode)
    if mode ~= nil then
        styles.depthMode = mode 

        if styles.depthMode then
            love.graphics.setDepthMode('lequal', true)
        else
            love.graphics.setDepthMode('always', false)
        end
    end
    return styles.depthMode
end

function cullingMode(mode)
    if mode ~= nil then
        styles.cullingMode = mode

        if styles.cullingMode then
            love.graphics.setMeshCullMode('back')
            love.graphics.setFrontFaceWinding('ccw')
        else
            love.graphics.setMeshCullMode('none')
        end
    end
    return styles.cullingMode
end

function light()
    -- TODO
end

function noLight()
    -- TODO
end

function loop()
    env.__loop = 1
end

function noLoop()
    env.__loop = 0
end

function redraw()
    env.__loop = -1
end

function tint()
    -- TODO
end

function noTint()
    -- TODO
end

function smooth()
    -- TODO
end

function noSmooth()
    -- TODO
end
