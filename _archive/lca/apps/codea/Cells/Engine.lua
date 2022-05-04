if love then
    return
end

local mt = {
    __call = function (_, t)
        t = t or {}
        setmetatable(t, table)
        return t
    end
}
setmetatable(table, mt)

table.__index = table
table.add = table.insert

table.unpack = unpack

function table:clear()
    local count = #self
    for i=count,1,-1 do
        self[i]=nil
    end
end

function table:removeItem(item)
    for i,v in ipairs(self) do
        if v == item then
            return self:remove(i)
        end
    end
end

function table:call(f, ...)
    for i,v in ipairs(self) do
        local typeof = type(f)
        if typeof == "string" then
            if v[f] then
                v[f](v, ...)
            end
        elseif typeof == "function" then
            f(v, ...)
        end
    end
    return self
end

function table:draw()
    self:call("draw")
end

function table:update(dt)
    self:call("update", dt)
end

function table:random()
    if #self > 0 then
        return self[math.random(#self)]
    end
end

W = WIDTH
H = HEIGHT

getmetatable(vec2()).clone = function(self)
    return vec2(self.x, self.y)
end

getmetatable(color()).random = function()
    return color(math.random(256)-1)
end

vector = class()

function vector.random(w, h)
    if w and h then
        return vec2(
            randomInt(w),
            randomInt(h))
    else
        w = w or 1
        return vec2(
            math.random()*2-1,
            math.random()*2-1)
        :normalize() * (len or 1)
    end

    return 
end

function mt.randomInScreen(w, h)
    return mt.random(W, H)
end

function circle(x, y, r)
    local n = 32

    local angle = 0
    local c = math.cos(angle)
    local s = math.sin(angle)

    for i=1,n do
        angle = TAU*i/n
        local c2 = math.cos(angle)
        local s2 = math.sin(angle)

        line(c*r, s*r, c2*r, s2*r)
        c,s = c2,s2
    end
end

function math.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

min = math.min
max = math.max

PI = math.pi
TAU = math.pi * 2

red = color(255,0,0)
green = color(0,255,0)
blue = color(0,0,255)
