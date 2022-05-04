local transform = love.math.newTransform()
function setTransform()
    transform:setMatrix(modelMatrix():unpack())
    love.graphics.replaceTransform(transform)
end

local function setColor(clr)
    love.graphics.setColor(clr.r, clr.g, clr.b, clr.a)
end

function displayMode(mode)
end

--- orientation
LANDSCAPE = 0
LANDSCAPE_LEFT = 1
LANDSCAPE_RIGHT = 2
LANDSCAPE_ANY = LANDSCAPE_LEFT + LANDSCAPE_RIGHT

PORTRAIT = 4
PORTRAIT_UPSIDE_DOWN = 8
PORTRAIT_ANY = PORTRAIT + PORTRAIT_UPSIDE_DOWN

ANY = LANDSCAPE_ANY + PORTRAIT_ANY

function supportedOrientations(orientations)
end

function background(r, g, b, a)
    local clr = color(r, g, b, a)
    love.graphics.clear(clr.r, clr.g, clr.b, clr.a)
end

function zLevel(level)
end

CENTER = 'center'
CORNER = 'corner'

LEFT = 'left'

DEGREES = 'degrees'
RADIANS = 'radians'

s0 = 0.01
s1 = 1.01
for i = 2, 20 do
    _G['s'..i] = i
end


function resetStyle()
    app.win:resetStyle()
end

function pushStyle()
    push('styles', app.win.styles)
end

function popStyle()
    app.win.styles = pop('styles')
end

function style(size, clr1, clr2)
    assert(size)

    strokeWidth(size)
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

function angleMode(angleMode)
    if angleMode then
        styles.angleMode = angleMode
    end
    return styles.angleMode or DEGREES
end

function fontName(fontName)
    styles.fontName = fontName or styles.fontName
    return styles.fontName
end
font = fontName -- alias

function fontSize(fontSize)
    styles.fontSize = fontSize or styles.fontSize
    return styles.fontSize
end

local fonts = table()
function getFont()
    local fontName = fontName()
    local fontSize = fontSize()

    local fontRef = fontName..'.'..tostring(fontSize)

    if not fonts[fontRef] then
        local fontPath = 'res/fonts/'..fontName..'.ttf'
        if love.filesystem.getInfo(fontPath) then
            fonts[fontRef] = love.graphics.newFont(fontPath, fontSize)
        else
            log('font not found : '..fontPath)
            fontPath = 'res/fonts/'..'Arial'..'.ttf'
            fonts[fontRef] = love.graphics.newFont(fontPath, fontSize)
        end
    end

    return fonts[fontRef]
end

local textCache = table()
function getText(font, str)
    if str == nil then return end

    local fontName = fontName()
    local fontSize = fontSize()

    local textRef = fontName..'.'..tostring(fontSize)..'.'..str

    if not textCache[textRef] then
        textCache[textRef] = love.graphics.newText(font, str)
    end
    return textCache[textRef]
end

function textMode(textMode)
    styles.textMode = textMode or styles.textMode
    return styles.textMode
end

function textWrapWidth(width)
    if width then
        styles.textWrapWidth = width
    end
    return styles.textWrapWidth
end

function textAlign(align)
    if align then
        styles.textAlign = align
    end
    return styles.textAlign
end

function textSize(str)
    local font = getFont()
    local text = getText(font, str:gsub(' ', '_'))

    return text:getWidth(), text:getHeight()
end

function text(str, x, y)
    if str == nil then return end

    setTransform()

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

    if styles.fill then
        setColor(styles.fill)
        if getOrigin() == BOTTOM_LEFT then
            love.graphics.draw(text, x, y+ht+.5, 0, 1, -1)
        else
            love.graphics.draw(text, x, y+.5)
        end
    end

    return wt, ht
end

function strokeWidth(width)
    if width then
        styles.strokeWidth = width
    end
    return styles.strokeWidth
end

function stroke(clr, ...)
    if clr then
        styles.stroke = color(clr, ...)
    end
    return styles.stroke
end

function noStroke()
    styles.stroke = nil
end

function fill(clr, ...)
    if clr then
        styles.fill = color(clr, ...)
    end
    return styles.fill
end

function noFill()
    styles.fill = nil
end

function tint(clr, ...)
    if clr then
        styles.tint = color(clr, ...)
    end
    return styles.tint
end

function noTint()
    styles.tint = nil
end

function smooth()
    styles.smooth = true
end

function noSmooth()
    styles.smooth = false
end

NORMAL = 'normal'
ADDITIVE = 'additive'
MULTIPLY = 'multiply'

function blendMode(mode)
    if mode then
        styles.blendMode = mode

        if styles.blendMode == NORMAL then
            love.graphics.setBlendMode('replace')

        elseif styles.blendMode == ADDITIVE then 
            love.graphics.setBlendMode('add')

        elseif styles.blendMode == MULTIPLY then 
            love.graphics.setBlendMode('multiply', 'premultiplied')
        end
    end
    return styles.blendMode
end

local decomposeCache = {}
local function decompose(vertices)
    if decomposeCache[vertices] and decomposeCache[vertices].n == #vertices then
        return decomposeCache[vertices].vertices
    end

    assert(type(vertices) == 'table' or type(vertices) == 'cdata')

    if type(vertices[1]) == 'table' or type(vertices[1]) == 'cdata' then -- array of vector
        local arrayOfVec = vertices
        vertices = table()
        local v
        for i=1,#arrayOfVec do
            v = arrayOfVec[i]
            vertices:insert(v.x)
            vertices:insert(v.y)
        end
        decomposeCache[arrayOfVec] = {n=#arrayOfVec, vertices=vertices}
    end

    return vertices
end

function point(x, y)
    if type(x) == 'table' or type(x) == 'cdata' then
        x, y = x.x, x.y
    end

    assert(type(x) == 'number')

    points({x, y})
end

function points(vertices)
    setTransform()
    if styles.stroke then
        vertices = decompose(vertices)
        setColor(styles.stroke)
        love.graphics.setPointSize(styles.strokeWidth)
        love.graphics.points(vertices)
    end
end

ROUND = 0
SQUARE = 1
PROJECT = 2

function lineCapMode(mode)
    if mode then
        styles.lineCapMode = mode
    end
    return styles.lineCapMode
end

function line(x1, y1, x2, y2)
    assert(type(x1) == 'number')

    setTransform()
    if styles.stroke then
        setColor(styles.stroke)
        love.graphics.setLineWidth(styles.strokeWidth)
        love.graphics.line(x1, y1, x2, y2)
    end
end

function lines(vertices)
    setTransform()
    if styles.stroke then
        vertices = decompose(vertices)
        if #vertices > 4 then
            setColor(styles.stroke)
            love.graphics.setLineWidth(styles.strokeWidth)
            love.graphics.line(vertices)
        end
    end
end

function polyline(vertices)
    lines(vertices)
end

function polygon(vertices)
    setTransform()
    if styles.stroke then
        vertices = decompose(vertices)
        setColor(styles.stroke)
        love.graphics.setLineWidth(styles.strokeWidth)
        love.graphics.polygon('line', vertices)
    end
end

function bezier(x1, y1, x2, y2, x3, y3, x4, y4)
    local f = bezier_proc({x1,x2,x3,x4}, {y1,y2,y3,y4})
    strokeWidth(5)
    for i=0,1,0.01 do 
        point(f(i))
    end
end

--[[
    a parametric function describing the Bezier curve determined by given control points,
    which takes t from 0 to 1 and returns the x, y of the corresponding point on the Bezier curve
]]
function bezier_proc(xv, yv)
    local reductor = {__index = function(self, ind)
            return setmetatable({tree = self, level = ind}, {__index = function(curves, ind)
                        return function(t)
                            local x1, y1 = curves.tree[curves.level-1][ind](t)
                            local x2, y2 = curves.tree[curves.level-1][ind+1](t)
                            return x1 + (x2 - x1) * t, y1 + (y2 - y1) * t
                        end
                    end})
        end
    }
    local points = {}
    for i = 1, #xv do
        points[i] = function(t) return xv[i], yv[i] end
    end
    return setmetatable({points}, reductor)[#points][1]
end

function rectMode(mode)
    if mode then
        styles.rectMode = mode
    end
    return styles.rectMode
end

function rect(x, y, w, h, r)
    h = h or w

    setTransform()
    if rectMode() == CENTER then
        x, y = x-w/2, y-h/2
    end

    if styles.fill then
        setColor(styles.fill)
        love.graphics.rectangle('fill', x, y, w, h, r, r, r)
    end

    if styles.stroke then
        setColor(styles.stroke)
        love.graphics.setLineWidth(styles.strokeWidth)
        love.graphics.rectangle('line', x, y, w, h, r, r, r)
    end
end

function circleMode(mode)
    if mode then
        styles.circleMode = mode
    end
    return styles.circleMode
end

function circle(x, y, r)
    setTransform()
    if circleMode() == CORNER then
        x, y = x-r, y-r
    end

    if styles.fill then
        setColor(styles.fill)
        love.graphics.circle('fill', x, y, r)
    end

    if styles.stroke then
        setColor(styles.stroke)
        love.graphics.setLineWidth(styles.strokeWidth)
        love.graphics.circle('line', x, y, r)
    end
end

function ellipseMode(mode)
    if mode then
        styles.ellipseMode = mode
    end
    return styles.ellipseMode
end

function ellipse(x, y, w, h)
    h = h or w

    setTransform()
    if ellipseMode() == CORNER then
        x, y = x-w, y-h
    end

    if styles.fill then
        setColor(styles.fill)
        love.graphics.ellipse('fill', x, y, w/2, h/2)
    end

    if styles.stroke then
        setColor(styles.stroke)
        love.graphics.setLineWidth(styles.strokeWidth)
        love.graphics.ellipse('line', x, y, w/2, h/2)
    end
end

function arc(x, y, r, a1, a2, n)
    local points = table()
    Geometry.arc(points, x, y, r, a1, a2, n)
    Geometry.draw(points, strokeWidth(), stroke())
end

function spriteMode(mode)
    if mode then
        styles.spriteMode = mode
    end
    return styles.spriteMode
end

function spriteSize(img)
    if type(img) == 'string' then
        img = image(img)
    end
    return img.width, img.height
end

function sprite(img, x, y, w, h)
    x = x or 0
    y = y or 0

    if type(img) == 'string' then
        img = image.getImage(img)
    end

    w = w or img.width
    h = h or img.height

    img:update()

    setTransform()
    if spriteMode() == CENTER then
        x, y = x-w/2, y-h/2
    end

    local sx, sy = w/img.width, h/img.height
    if getOrigin() == BOTTOM_LEFT then
        love.graphics.draw(img.canvas, x, y+h, 0, sx, -sy)
    else
        love.graphics.draw(img.canvas, x, y, 0, sx, sy)
    end
end

function clip(x, y, w, h)    
    love.graphics.setScissor(x, y, w, h)
end

function noClip()
    love.graphics.setScissor()
end

function light()
end

function noLight()
end
