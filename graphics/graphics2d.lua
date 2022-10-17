local Graphics = class 'GraphicsBase'

DEFAULT_FONT_NAME = 'Arial'
DEFAULT_FONT_SIZE = 18

function Graphics.setup()
    Graphics.resources = {}
end

function Graphics.release()
    for k,res in pairs(Graphics.resources) do
        Graphics.resources[k] = nil
    end

    Graphics.resources = {}
end

function Graphics.background(clr, ...)
    if type(clr) == 'number' then clr = Color(clr, ...) end
    clr = clr or colors.black
    local r, g, b, a = clr:unpack()
    love.graphics.clear(r, g, b, a, true, true)
end

function Graphics.zLevel(level)
    -- TODO : need to batch drawing calls after sorting them...
end

function Graphics.clip(...)
    love.graphics.setScissor(...)
end

function Graphics.noClip()
    love.graphics.setScissor()
end

function Graphics.textResource(txt, wraplimit)
    local font = love.graphics.getFont()

    local fontRef = fontName()..'.'..fontSize()
    local resName = fontRef..':'..txt
    local res = Graphics.resources[resName]
    if not res then
        local drawableText = love.graphics.newText(font)
        if wraplimit then
            drawableText:setf(txt, wraplimit, 'left')
        else
            drawableText:set(txt)
        end
        Graphics.resources[resName] = {
            text = drawableText,
        }
        Graphics.resources[resName].w, Graphics.resources[resName].h = Graphics.resources[resName].text:getDimensions()
        res = Graphics.resources[resName]
    end

    return res
end

function Graphics.textSize(txt)
    local res = Graphics.textResource(txt)
    return res.w, res.h
end

function Graphics.text(txt, x, y, wraplimit, maxheight)
    if type(txt) == 'table' then
        local t = txt
        txt = ''
        for _,v in ipairs(t) do
            txt = txt .. tostring(v) .. ' '
        end
    else
        txt = tostring(txt)
    end

    local res = Graphics.textResource(txt, wraplimit)
    local w, h = res.w, res.h

    x = x or 0
    if not y then
        y = textPosition()
    end

    if Engine.origin == TOP_LEFT then
        textPosition(y + h)
    else
        textPosition(y - h)
    end

    if textMode() == CENTER then
        x = x - w / 2
        y = y - h / 2
    end

    local clr = __textColor() or __stroke()
    if clr then
        pushMatrix()
        do
            if Engine.origin == BOTTOM_LEFT then
                if maxheight then
                    translate(x, y)
                else
                    translate(x, y+h)
                end
            else
                translate(x, y)
            end

            if maxheight then
                pushMatrix()
                resetMatrix()
                res.img = res.img or Image(wraplimit, maxheight)
                setContext(res.img)
                background(colors.white)
            end

            love.graphics.setBlendMode('alpha')
            love.graphics.setColor(clr:unpack())

            if Engine.origin == BOTTOM_LEFT then
                if maxheight then
                    love.graphics.draw(res.text, 0, maxheight, 0, 1, -1)
                else
                    love.graphics.draw(res.text, 0, 0, 0, 1, -1)
                end
            else
                love.graphics.draw(res.text, 0, 0, 0, 1, 1)
            end

            if maxheight then
                setContext()
                popMatrix()
                sprite(res.img)
            end
        end
        popMatrix()
    end

    return w, h
end

function Graphics.lines3D(t)
    local m = Mesh(t)
    m.drawMode = 'points'
    m:draw()
end

function Graphics.spriteSize(img)
    img = Image.getImage(img)
    return img.width, img.height
end

function Graphics.sprite(img, x, y, w, h)    
    img = Image.getImage(img)
    if not img then return end

    x = x or 0
    y = y or 0

    w = w or img.data:getWidth()
    h = h or img.data:getHeight()

    if spriteMode() == CENTER then
        x = x - w / 2
        y = y - h / 2
    end

    local clr = __tint() or colors.white
    love.graphics.setColor(clr:unpack())

    img:draw(x, y, w, h)
end

local shape
function Graphics.beginShape(shapeMode)
    shape = Shape(shapeMode)
end

function Graphics.vertex(x, y)
    shape:vertex(x, y)
end

function Graphics.scaleShape(n)
    shape:scale(n)
end

function Graphics.endShape(drawMode)
    shape:setDrawMode(drawMode)
    shape:draw()
    return shape
end

function Graphics.table2points(t, ...)
    if type(t) ~= 'table' then t = {t, ...} end

    local points
    if type(t[1]) == 'table' and t[1].x then
        points = table()
        for i,v in ipairs(t) do
            points:insert(v.x)
            points:insert(v.y)
        end
    else
        points = t
    end
    return points
end
