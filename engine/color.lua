class 'color'

function color.hexa(hexa)
    local r, g, b

    r = hexa % 256
    hexa = (hexa - r) / 256

    g = hexa % 256
    hexa = (hexa - g) / 256

    b = hexa % 256

    return color(r/255, g/255, b/255)
end

function color.reverse(clr)
    return color(
        1-clr.r,
        1-clr.g,
        1-clr.b)
end

function color:init(r, g, b, a)
    self.r = r or 0
    self.g = g or 0
    self.b = b or 0
    self.a = a or 1
end

white = color(1, 1, 1)
black = color(0, 0, 0)
