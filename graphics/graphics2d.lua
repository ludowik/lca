local Graphics = class 'GraphicsBase'

DEFAULT_FONT_NAME = 'Arial'

function Graphics.setup()
    Graphics.resources = {}
end

function Graphics.release()
    Graphics.resources = nil
end

function Graphics.background(clr, ...)
    if type(clr) == 'number' then clr = Color(clr, ...) end
    clr = clr or colors.black
    local r, g, b, a = clr:unpack()
    love.graphics.clear(r, g, b, a, true, true)
end

function Graphics.zLevel(level)
    -- TODO
end

function Graphics.clip(...)
    love.graphics.setScissor(...)
end

function Graphics.noClip()
    love.graphics.setScissor()
end

function Graphics.textResource(txt)
    local font = love.graphics.getFont()

    local resName = txt .. fontSize()
    local res = Graphics.resources[resName]
    if not res then
        Graphics.resources[resName] = {
            text = love.graphics.newText(font, txt),
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

function Graphics.text(txt, x, y)
    if type(txt) == 'table' then
        local t = txt
        txt = ''
        for _,v in ipairs(t) do
            txt = txt .. tostring(v) .. ' '
        end
    else
        txt = tostring(txt)
    end

    local res = Graphics.textResource(txt)    
    local w, h = res.w, res.h

    x = x or 0
    if not y then
        y = textPosition()
        textPosition(y + h)
    end

    if textMode() == CENTER then
        x = x - w / 2
        y = y - h / 2
    end

    local clr = textColor() or stroke()
    if clr then
        love.graphics.setBlendMode('alpha')
        love.graphics.setColor(clr:unpack())

        if Engine.origin == BOTTOM_LEFT then
            love.graphics.draw(res.text, x, y, 0, 1, -1)
        else
            love.graphics.draw(res.text, x, y, 0, 1, 1)
        end
    end

    return w, h
end

function Graphics.lines3D()
end

function Graphics.spriteSize(img)
    img = Image.getImage(img)
    return img.width, img.height
end

function Graphics.sprite(img, x, y, w, h)
    img = Image.getImage(img)

    x = x or 0
    y = y or 0

    w = w or img.data:getWidth()
    h = h or img.data:getHeight()

    if spriteMode() == CENTER then
        x = x - w / 2
        y = y - h / 2
    end

    img:draw(x, y, w, h)
end

local shape
function Graphics.beginShape()
    shape = Shape()
end

function Graphics.vertex(x, y)
    shape:vertex(x, y)
end

function Graphics.scaleShape(n)
    shape:scale(n)
end

function Graphics.endShape(mode)
    shape.mode = mode or shape.mode
    shape:draw(mode)
    return shape
end
