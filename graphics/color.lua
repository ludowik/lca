class 'Color'

function Color.setup()
    colors = {
        white = Color(1, 1, 1),
        black = Color(0, 0, 0),

        gray = Color(0.5, 0.5, 0.5),

        red = Color(210, 70, 50), -- 1, 0, 0),
        green = Color(50, 170, 120), -- 0, 1, 0),
        blue = Color(50, 120, 170), -- 0, 0, 1),

        yellow = Color(245, 225, 50),
        orange = Color(1, 165, 0),
    }
end

function Color:init(r, g, b, a)
    r = r or 0
    g = g or r
    b = b or r

    if r > 1 or g > 1 or b > 1 then
        r = r / 255
        g = g / 255
        b = b / 255
        a = a and (a / 255) or 1
    else        
        a = a or 1
    end

    self.r = r
    self.g = g
    self.b = b
    self.a = a
end

function Color:set(r, g, b, a)
    self:init(r, g, b, a)
    return self
end

function Color:unpack()
    return self.r, self.g, self.b, self.a
end

function Color.random()
    return Color(
        random(),
        random(),
        random(),
        1)
end

function Color:contrast()
    local lum = (
        0.2125 * self.r +
        0.7154 * self.g + 
        0.0721 * self.b)

    if lum < 0.3 then return
        colors.white
    end
    return colors.black
end

function Color:complementary()
    return Color(
        1 - self.r,
        1 - self.g,
        1 - self.b,
        1)
end

function Color:grayscale()
    local gray = (
        0.299 * self.r +
        0.587 * self.g +
        0.114 * self.b)
    return Color(gray, gray, gray)
end

function Color:alpha(a)
    return Color(
        self.r,
        self.g,
        self.b,
        a > 1 and a / 255 or a)
end

function Color.hexa(hexa)
    local r, g, b

    r = hexa % 256
    hexa = (hexa - r) / 256

    g = hexa % 256
    hexa = (hexa - g) / 256

    b = hexa % 256

    return Color(r/255, g/255, b/255)
end

function Color.hsl(hue, sat, lgt, alpha)
    assert(hue)
    sat = sat or 0.5
    lgt = lgt or 0.5
    alpha = alpha or 1

    if sat <= 0 then
        return Color(lgt, lgt, lgt, alpha)
    end

    hue = hue * 6 -- We will split hue into 6 sectors    

    local c = (1-math.abs(2*lgt-1))*sat
    local x = (1-math.abs(hue%2-1))*c

    local m,r,g,b = (lgt-.5*c), 0,0,0

    if     hue < 1 then r,g,b = c,x,0
    elseif hue < 2 then r,g,b = x,c,0
    elseif hue < 3 then r,g,b = 0,c,x
    elseif hue < 4 then r,g,b = 0,x,c
    elseif hue < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end

    return Color(r+m, g+m, b+m, alpha)
end

function Color.hsb(hue, sat, val, alpha)
    assert(hue)
    sat = sat or 0.5
    val = val or 1
    a = a or 1

    if sat <= 0 then 
        return Color(val, val, val, alpha) -- Return early if grayscale
    end

    hue = hue * 6 -- We will split hue into 6 sectors    

    local sector = floor(hue)
    local tint1 = val * (1 - sat)
    local tint2 = val * (1 - sat * (hue - sector))
    local tint3 = val * (1 - sat * (1 + sector - hue))
    local r, g, b
    if sector == 1 then
        -- Yellow to green
        r = tint2
        g = val
        b = tint1
    elseif sector == 2 then
        -- Green to cyan
        r = tint1
        g = val
        b = tint3
    elseif sector == 3 then
        -- Cyan to blue
        r = tint1
        g = tint2
        b = val
    elseif sector == 4 then
        -- Blue to magenta
        r = tint3
        g = tint1
        b = val
    elseif sector == 5 then
        -- Magenta to red
        r = val
        g = tint1
        b = tint2
    else
        -- Red to yellow (sector could be 0 or 6)
        r = val
        g = tint3
        b = tint1
    end
    return Color(r, g, b, alpha)
end
