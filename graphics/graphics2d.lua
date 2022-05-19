local Graphics = class 'GraphicsBase'

function Graphics.background(clr, ...)
    if type(clr) == 'number' then clr = Color(clr, ...) end
    clr = clr or colors.black
    local r, g, b, a = clr:unpack(),
    love.graphics.clear(r, g, b, a, true, true)
end

function Graphics.clip(...)
    love.graphics.setScissor(...)
end

function Graphics.fontName(name)
end

function Graphics.fontSize(size)
    _fontSize = size or _fontSize or 12
    if size then
        love.graphics.setNewFont(size)
    end
    return _fontSize
end

local resources = {}
function Graphics.textRes(txt)
    local font = love.graphics.getFont()

    local resName = txt .. Graphics.fontSize()
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
        y = textPosition
        textPosition = textPosition + h
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
end

function Graphics.sprite(img, x, y, w, h)
    x = x or 0
    y = y or 0

    w = w or img.data:getWidth()
    h = h or img.data:getHeight()

    if spriteMode() == CENTER then
        x = x - w / 2
        y = y - h / 2
    end

    img:draw(x, y, w/img.data:getWidth(), h/img.data:getHeight())
end

class 'Image'

function Image:init(name, ...)
    if type(name) == 'string' then
        self.data = love.graphics.newImage(name)
    
    else
        local w, h = name, ...
        h = h or w
        self.imagedata = love.image.newImageData(w, h)
        self.data = love.graphics.newImage(self.imagedata)
            
    end
end

function Image:getWidth()
    return self.data:getWidth()
end

function Image:getHeight()
    return self.data:getHeight()
end

function Image:draw(x, y, w, h)
    w = w or self:getWidth()
    h = h or self:getHeight()

    love.graphics.draw(self.data,
        x, y,
        0,
        w/self:getWidth(), h/self:getHeight())
end

function Image:set(x, y)
end
