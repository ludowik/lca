Color = class()

function Color:init(r, g, b, a)
    if type(r) == 'table' then
        local clr = r
        r, g, b, a = clr.r, clr.g, clr.b, clr.a
    end
    self.r = r or 0
    self.g = g or 0
    self.b = b or 0
    self.a = a or 1
end

function Color.copy(clr)
    return Color(clr)
end

function Color.tocolor(clr, ...)
    if clr == nil then
        return colors.white

    elseif type(clr) == 'table' then
        return clr

    else
        return Color(clr, ...)
    end
end

function Color.tocomposants(clr)
    return clr.r, clr.g, clr.b, clr.a
end

function Color.random()
    return Color(math.random(), math.random(), math.random(), 1)
end

function Color:alpha(a)
    local clr = self:copy()
    clr.a = a
    return clr
end

-- LuaFormatter off

colors = {
    black = Color(0, 0, 0),
    white = Color(1, 1, 1),

    gray = Color(.5, .5, .5),

    red   = Color(1, 0, 0),
    green = Color(0, 1, 0),
    blue  = Color(0, 0, 1),

    yellow = Color(1, 1, 0),
}

-- LuaFormatter on
