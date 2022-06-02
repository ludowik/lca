local Graphics = class 'GraphicsBase'

DEFAULT_FONT_NAME = 'Arial'

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

local resources = {}
function Graphics.textRes(txt)
    local font = love.graphics.getFont()

    local resName = txt .. fontSize()
    local res = resources[resName]
    if not res then
        resources[resName] = {
            text = love.graphics.newText(font, txt),
        }
        resources[resName].w, resources[resName].h = resources[resName].text:getDimensions()
        res = resources[resName]
    end

    return res
end

function Graphics.textSize(txt)
    local res = Graphics.textRes(txt)
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

    local res = Graphics.textRes(txt)    
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
        love.graphics.draw(res.text, x, y)
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

function Graphics.endShape(mode)
    shape.mode = mode or shape.mode
    shape:draw(mode)
    return shape
end
