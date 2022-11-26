class 'Color'

function Color.setup()
    colors = {
        white = Color(1, 1, 1),
        black = Color(0, 0, 0),

        lightgray = Color(0.75, 0.75, 0.75),
        gray = Color(0.5, 0.5, 0.5),
        darkgray = Color(0.25, 0.25, 0.25),

        red = Color(210, 70, 50), -- 1, 0, 0),
        green = Color(50, 170, 120), -- 0, 1, 0),
        blue = Color(50, 120, 170), -- 0, 0, 1),

        yellow = Color(245, 225, 50),
        magenta = Color(1, 0, 1),
        cyan = Color(0, 1, 1),
        orange = Color(1, 165, 0),
        purple = Color(0.5, 0, 0.5),

        brown = Color(165,  42,  42),
        beige = Color(245, 245, 220),
        azure = Color(240, 255, 255),

        transparent = Color(0, 0, 0, 0)
    }
end

if ffi then
    ffi.cdef [[
        typedef union color {
            struct {
                float r;
                float g;
                float b;
                float a;
            };
            float values[4];
        } color;
    ]]

--    ffi.metatype('color', Color)
end

function Color:init(r, g, b, a)
--    self = ffi.new('color')

    if type(r) == 'table' or type(r) == 'cdata' then r, g, b, a = r.r, r.g, r.b, r.a end

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

--    return self
end

function Color:set(r, g, b, a)
    self:init(r, g, b, a)
    return self
end

function Color.rgb(...)
    return Color(...)
end

function Color:__tostring()
    return self.r .. ',' .. self.g .. ',' .. self.b .. ',' .. self.a
end

function Color:unpack()
    return self.r, self.g, self.b, self.a
end

function Color.random(self)
    if self then
        return Color(
            self.r + random(0.05),
            self.g + random(0.05),
            self.b + random(0.05),
            1)
    else
        return Color(
            random(),
            random(),
            random(),
            1)
    end
end

function Color.__add(clr1, clr2)
    return Color(
        min(1, clr1.r + clr2.r),
        min(1, clr1.g + clr2.g),
        min(1, clr1.b + clr2.b),
        min(1, clr1.a + clr2.a))
end

function Color:__mul(coef)
    return Color(self):mul(coef)
end

function Color:mul(coef)
    self.r = self.r * coef
    self.g = self.g * coef
    self.b = self.b * coef
    self.a = self.a * coef
    return self
end

function Color:__sub(clr)
    return Color(
        ( self.r - clr.r ),
        ( self.g - clr.g ),
        ( self.b - clr.b ),
        ( self.a - clr.a )
    )
end

function Color.__div(p, coef)
    return Color.__mul(p, 1/coef)
end

function Color.__eq(clr1, clr2)
    if (clr1 and
        clr2 and
        clr1.r == clr2.r and
        clr1.g == clr2.g and
        clr1.b == clr2.b and
        clr1.a == clr2.a)
    then
        return true
    end
end

function Color.min(a, b)
    return Color(
        min(a.r, b.r),
        min(a.g, b.g),
        min(a.b, b.b),
        1)
end

function Color.max(a, b)
    return Color(
        max(a.r, b.r),
        max(a.g, b.g),
        max(a.b, b.b),
        1)
end

function Color.avg(a, b)
    return Color(
        (a.r + b.r)/2,
        (a.g + b.g)/2,
        (a.b + b.b)/2,
        1)
end

function Color.mix(clr1, clr2, dst)
    dst = dst or 0.5
    local src = 1 - dst

    return Color(
        max(0, clr1.r * src + clr2.r * dst),
        max(0, clr1.g * src + clr2.g * dst),
        max(0, clr1.b * src + clr2.b * dst),
        max(0, clr1.a * src + clr2.a * dst))
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

function Color.grayScaleLightness(clr, to)
    local r,g,b = clr.r, clr.g, clr.b
    local c = (max(r,g,b) + min(r,g,b)) / 2
    if to then
        to.r, to.g, to.b, to.a = c, c, c, clr.a
        return to
    else
        return Color(c,c,c,clr.a)
    end
end

function Color.grayScaleAverage(clr, to)
    local r,g,b = clr.r, clr.g, clr.b
    local c = (r+g+b) / 3
    if to then
        to.r, to.g, to.b, to.a = c, c, c, clr.a
        return to
    else
        return Color(c,c,c,clr.a)
    end
end

function Color.grayScaleLuminosity(clr, to)
    local r,g,b = clr.r, clr.g, clr.b
    local c = 0.21*r + 0.72*g + 0.07*b
    if to then
        to.r, to.g, to.b, to.a = c, c, c, clr.a
        return to
    else
        return Color(c,c,c,clr.a)
    end
end

function Color.grayScaleIntensity(clr, to)
    local r,g,b = clr.r, clr.g, clr.b
    local c = 0.299*r + 0.587*g + 0.114*b
    if to then
        to.r, to.g, to.b, to.a = c, c, c, clr.a
        return to
    else
        return Color(c,c,c,clr.a)
    end
end

Color.grayscale = Color.grayScaleIntensity

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
    hexa = (hexa - r) / 255

    g = hexa % 256
    hexa = (hexa - g) / 255

    b = hexa % 256

    return Color(r/255, g/255, b/255)
end

function Color.darken(clr, pct)
    pct = pct or -50
    return Color.lighten(clr, pct)
end

function Color.lighten(clr, pct)
    pct = pct or 50    
    local h, s, l, a = Color.rgb2hsl(clr.r, clr.g, clr.b, clr.a)
    l = l + l * pct / 100
    return Color.hsl(h,s,l,a)
end

function Color.visibleColor(clr)
    local cm = ( clr.r + clr.g + clr.b ) / 3

    local m

    if cm < 0.5 then
        m = 1
    else
        m = 0
    end

    return Color(
        m,
        m,
        m,
        clr.a)
end

function Color.hsl(hue, sat, lgt, alpha)
    assert(hue)
    if hue > 1 then
        hue = hue / 255
    end

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
    if hue > 1 then
        hue = hue / 255
    end

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

function Color.rgb2hsl(...)
    local clr = Color(...)
    local r, g, b, a = clr.r, clr.g, clr.b, clr.a

    local max, min = math.max(r, g, b), math.min(r, g, b)
    local h = (max + min)*.5
    local s, l = h, h

    if max == min then
        h, s = 0, 0
    else
        local d = max - min
        s = (l > 0.5) and d / (2 - max - min) or d / (max + min)

        if max == r then
            h = (g - b) / d + (g < b and 6 or 0)
        elseif max == g then
            h = (b - r) / d + 2
        elseif max == b then
            h = (r - g) / d + 4
        end

        h = h / 6
    end

    return h, s, l, a
end
