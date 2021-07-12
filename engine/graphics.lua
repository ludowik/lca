function background(r, g, b, a)
    local clr = color(r, g, b, a)
    love.graphics.clear(clr.r, clr.g, clr.b, clr.a)
end

CENTER = 'center'
CORNER = 'corner'

function resetStyles()
    return table{
        fontName = 'Arial',
        fontSize = 14,
        
        textMode = CORNER,
        textColor = white,
        
        stroke = white,
        fill = black,
        
        rectMode = CORNER,
    }
end

function textMode(textMode)
    styles.textMode = textMode or styles.textMode
    return styles.textMode
end

function textSize(str)
    local font = getFont()
    local text = getText(font, str)

    return text:getWidth(), text:getHeight()
end

function text(str, x, y)
    x = x or 0
    y = y or styles.yText or 0

    local font = getFont()
    local text = getText(font, str)

    local wt, ht = text:getWidth(), text:getHeight()

    if textMode() == CENTER then
        x = x - wt/2
        y = y - ht/2
    end

    styles.yText = (styles.yText or 0) + ht

    if styles.textColor then
        love.graphics.setColor(styles.textColor.r, styles.textColor.g, styles.textColor.b)
        love.graphics.draw(text, x, y+.5)
    end
end

function fontName(fontName)
    styles.fontName = fontName or styles.fontName
    return styles.fontName
end

function fontSize(fontSize)
    styles.fontSize = fontSize or styles.fontSize
    return styles.fontSize
end

local fonts = table()
function getFont()
    local fontName = fontName()
    local fontSize = fontSize()

    local fontRef = fontName..'.'..tostring(fontSize)

    fonts[fontRef] = fonts[fontRef ] or love.graphics.newFont(
        'res/fonts/'..fontName..'.ttf', fontSize)

    return fonts[fontRef]
end

function getText(font, str)
    return love.graphics.newText(font, str)
end

function textColor(clr)
    styles.textColor = clr or styles.textColor
    return styles.textColor
end

function stroke(clr)
    styles.stroke = clr or styles.stroke
    return styles.stroke
end

function noStroke()
    styles.stroke = nil
end

function fill(clr)
    styles.fill = clr or styles.fill
    return styles.fill
end

function noFill()
    styles.fill = nil
end

function rectMode()
    styles.rectMode = clr or styles.rectMode
    return styles.rectMode
end

function rect(x, y, w, h, r)
    local transform = love.math.newTransform()
    transform:setMatrix(modelMatrix():unpack())
    love.graphics.replaceTransform(transform)

    if styles.fill then
        love.graphics.setColor(styles.fill.r, styles.fill.g, styles.fill.b)
        love.graphics.rectangle('fill', x, y, w, h, r, r, r)
    end

    if styles.stroke then
        love.graphics.setColor(styles.stroke.r, styles.stroke.g, styles.stroke.b)
        love.graphics.rectangle('line', x, y, w, h, r, r, r)
    end
end
