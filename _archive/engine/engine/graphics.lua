gx = class()

function gx.setup()
    CENTER = 'center'
    CORNER = 'corner'

    RIGHT = 'right'
    
    for name,f in pairs(gx) do
        if type(f) == 'function' then
            _G[name] = f
        end
    end
end

function gx.canvas(w, h)
    return love.graphics.newCanvas(w, h)
end

function gx.reset()
    resetMatrix()
    
    gx.styles = {}

    gx.font('res/fonts/Arial.ttf', 24)
    
    gx.stroke(white)
    gx.fill(transparent)
    
    gx.rectMode(CORNER)
end

function gx.background(clr)
    love.graphics.setBackgroundColor(clr:unpack())
    love.graphics.clear()
end

function gx.stroke(clr)
    gx.styles.stroke = clr
end

function gx.fill(clr)
    gx.styles.fill = clr
end

function gx.font(name, size)
    gx.styles.fontName = name
    gx.styles.fontSize = size
    gx.fontRef = love.graphics.newFont(gx.styles.fontName, gx.styles.fontSize)
    love.graphics.setFont(gx.fontRef)
end

function gx.fontSize(size)
    gx.font(gx.styles.fontName, size)
end

function gx.textSize(txt)
    local text = love.graphics.newText(gx.fontRef, txt)
    return text:getWidth(), text:getHeight()
end

local yLast = 0

function gx.text(txt, x, y, mode)
    y = y or yLast
    mode = mode or CORNER

    local w, h = gx.textSize(txt)
    if mode == CENTER then
        x = x - w/2
        y = y - h/2

    elseif mode == RIGHT then
        x = x - w
        y = y - h

    end

    love.graphics.setColor(gx.styles.stroke:unpack())
    love.graphics.print(txt, x, y+h, 0, 1, -1)

    yLast = y
end

function gx.strokeWidth(width)
    love.graphics.setLineWidth(width)
end

function gx.line(x1, y1, x2, y2)
    love.graphics.setColor(gx.styles.stroke:unpack())
    love.graphics.line(x1, y1, x2, y2)
end

function gx.rectMode(mode)
    gx.styles.rectMode = mode
end

function gx.rect(x, y, w, h, mode)
    mode = mode or gx.styles.rectMode
    if mode == CENTER then
        x = x - w/2
        y = y - h/2 
    end
    
    love.graphics.setColor(gx.styles.stroke:unpack())
    love.graphics.rectangle('line', x, y, w, h)
end

function gx.circle(x, y, r)
    love.graphics.setColor(gx.styles.stroke:unpack())
    love.graphics.circle('line', x, y, r)
end
