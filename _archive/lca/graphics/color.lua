color = class 'Color'

function color:init(r, g, b, a)
    if type(r) == 'table' then
        r, g, b, a = r.r, r.g, r.b, r.a
    end
    
    self.r = r or 0
    self.g = g or r or 0
    self.b = b or r or 0
    self.a = a or 1
    
    if self.r > 1 then self.r = self.r / 255 end
    if self.g > 1 then self.g = self.g / 255 end
    if self.b > 1 then self.b = self.b / 255 end
    if self.a > 1 then self.a = self.a / 255 end
end

function color.random()
    return color(math.random(), math.random(), math.random())
end

function color.hexa(hexa)
    local r, g, b

    r = hexa % 256
    hexa = (hexa - r) / 256

    g = hexa % 256
    hexa = (hexa - g) / 256

    b = hexa % 256

    return color(r/255, g/255, b/255)
end


function color:reverse()
    return color(
        1-self.r,
        1-self.g,
        1-self.b)
end

function color:grayscale()
    local gray = 0.299*self.r + 0.587*self.g + 0.114*self.b
    return color(gray, gray, gray)
end
