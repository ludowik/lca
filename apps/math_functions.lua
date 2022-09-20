function setup()    
    supportedOrientations(LANDSCAPE_ANY)
    setOrigin(BOTTOM_LEFT)

    Functions()
end

function update()
    Functions:update()
end

function draw()
    background()

    translate(W/4, H/4)

    for i,f in ipairs(Functions.list) do
        f:draw(i == current)
    end
    Functions.list[current]:draw(true)

    stroke(colors.blue)

    line(-W, 0, W, 0)
    line(0, -H, 0, H)
end

function keyboard(key)
    if key =='down' then
        if current == #Functions.list then
            current = 1
        else
            current = current + 1
        end
    elseif key =='up' then
        if current == 1 then
            current = #Functions.list
        else
            current = current - 1
        end
    end
end

dx = 0.01

class 'Functions'

Functions.functions = table{
    {'exp'  , math.exp},
    {'log 2' , math.log, 2},
    {'log e' , math.log},
    {'log 10', math.log10},

    {'cos'  , math.cos},
    {'cosh' , math.cosh},
    {'sin'  , math.sin},
    {'sinh' , math.sinh},
    {'tan'  , math.tan},
    {'tanh' , math.tanh},

    {'acos' , math.acos},
    {'asin' , math.asin},
    {'atan' , math.atan},

    {'sqrt' , math.sqrt},
    {'pow2' , math.pow, 2},

    {'fmod' , math.fmod, 2},

    {'ceil' , math.ceil},
    {'floor', math.floor},

    {'noise', noise},

    {'a * x + b', function (x) return a*x+b end, 2, 0.5},
}

function Functions:init()
    parameter.integer('current', 1, #Functions.functions, 1)
    
    parameter.number('dx', 0.001, 0.1, 0.01, function () Functions.needUpdate = true end)

    parameter.number('a', -10, 10, 2.0, function () Functions.needUpdate = true end)
    parameter.number('b', -10, 10, 0.5, function () Functions.needUpdate = true end)
    
    for name,f in pairs(tween.easing) do
        Functions.functions:insert(0, {name, f, 0, W/8*dx, W/8*dx})
    end    

    Functions.list = table(Functions.functions):map(function (list, i, t) return Function(t) end)
end

function Functions:update()
    if self.needUpdate then
        self.needUpdate = false
        for _,f in ipairs(Functions.list) do
            f:update()
        end
    end
end

class 'Function'

function Function:init(t)
    self.label = t[1]
    self.f = t[2]
    self.param = table.extract(t, 3)

    self:set()
end

function Function:set()
    self.points = table()

    -- dx = 0.01

    local size = max(W, H)
    local x = -size * dx
    for i=-size,size do
        self.points:add(x / dx)
        self.points:add(self.f(x, self.param:unpack()) / dx)

        x = x + dx
    end

    local sx, sy, npoints = 0, 0, 0
    for i=1,#self.points,2 do
        if Rect(0, 0, W, H):contains(self.points[i], self.points[i+1]) then
            sx = sx + self.points[i]
            sy = sy + self.points[i+1]
            npoints = npoints + 1
        end
    end

    self.tx = sx / npoints 
    self.ty = sy / npoints
end

function Function:update()    
    self:set()
end

function Function:draw(current)
    if current then
        strokeSize(2)
        stroke(colors.red)
        fontSize(20)
        textColor(colors.white)
    else
        strokeSize(1)
        stroke(colors.darkgray)
        fontSize(15)
        textColor(colors.darkgray)
    end

    polyline(self.points)

    textMode(CENTER)
    text(self.label, self.tx, self.ty)
end
