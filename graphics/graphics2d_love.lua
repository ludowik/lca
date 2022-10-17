local Graphics = class 'GraphicsLove' : extends(GraphicsBase)

function Graphics:init()
    push2_G(Graphics)
    love.graphics.setLineStyle('smooth')
end

--[[
love.graphics.points : draw one or more points
    x, y, ...
    {x, y, ...}
    {{x, y, r, g, b, a}, ...}
]]
function Graphics.point(...)
    Graphics.points(...)
end

function Graphics.points(...)
    local t = Graphics.table2points(...)
    if #t == 0 then return end

    if __stroke() then
        love.graphics.setColor(__stroke():unpack())
        love.graphics.setPointSize(strokeSize())   
    end
    love.graphics.points(t)
end

--[[
love.graphics.line : draw lines between points (2 points at least)
    x1, y1, x2, y2, ... 
    {x1, y1, x2, y2, ...}
]]
function Graphics.line(...)
    Graphics.lines(...)
end

function Graphics.lines(...)
    if not __stroke() then return end
    
    local t = Graphics.table2points(...)
    if #t == 0 then return end    

    love.graphics.setColor(__stroke():unpack())
    love.graphics.setLineWidth(strokeSize())

    for i=1,#t,4 do
        love.graphics.line(t[i], t[i+1], t[i+2], t[i+3])
    end
end

function Graphics.polyline(...)
    local t = Graphics.table2points(...)
    
    if #t < 2 then return end
    if #t % 2 == 1 then table.insert(t, t[#t]) end

    love.graphics.setColor(__stroke():unpack())
    love.graphics.setLineWidth(strokeSize())
    love.graphics.line(t)
end

--[[
love.graphics.polygon : draw a polygon (3 points at least)
    x1, y1, x2, y2, x3, y3, ... 
    {x1, y1, x2, y2, x3, y3, ...}
]]
function Graphics.polygon(...)
    local t = Graphics.table2points(...)
    
    if #t < 3 then return end

    if __fill() then
        love.graphics.setColor(__fill():unpack())
        love.graphics.polygon('fill', t)
    end
    if __stroke() then
        love.graphics.setColor(__stroke():unpack())
        love.graphics.setLineWidth(strokeSize())
        love.graphics.polygon('line', t)
    end
end

function Graphics.bezier(x1, y1, x2, y2, x3, y3, x4, y4)
    local f = Graphics.bezier_proc({x1,x2,x3,x4}, {y1,y2,y3,y4})
    strokeSize(5)
    for i=0,1,0.01 do 
        point(f(i))
    end
end

--[[
    a parametric function describing the Bezier curve determined by given control points,
    which takes t from 0 to 1 and returns the x, y of the corresponding point on the Bezier curve
]]
function Graphics.bezier_proc(xv, yv)
    local reductor = {__index = function(self, ind)
            return setmetatable({tree = self, level = ind}, {__index = function(curves, ind)
                        return function(t)
                            local x1, y1 = curves.tree[curves.level-1][ind](t)
                            local x2, y2 = curves.tree[curves.level-1][ind+1](t)
                            return x1 + (x2 - x1) * t, y1 + (y2 - y1) * t
                        end
                    end})
        end
    }
    local points = {}
    for i = 1, #xv do
        points[i] = function(t) return xv[i], yv[i] end
    end
    return setmetatable({points}, reductor)[#points][1]
end

function Graphics.arc(x, y, r, a1, a2, n)
    local points = table()
    Geometry.arc(points, x, y, r, a1, a2, n)
    Geometry.draw(points, strokeSize(), __stroke())
end

function Graphics.rect(x, y, w, h, rx, ry)
    h = h or w

    if rectMode() == CENTER then
        x = x - w / 2
        y = y - h / 2
    end

    if __fill() then
        love.graphics.setColor(__fill():unpack())
        love.graphics.rectangle('fill', x, y, w, h, rx, ry)
    end

    if __stroke() then
        love.graphics.setColor(__stroke():unpack())
        love.graphics.setLineWidth(strokeSize())
        love.graphics.rectangle('line', x, y, w, h, rx, ry)
    end
end

local SEGMENTS = 32
function Graphics.circle(x, y, radius)
    if circleMode() == CORNER then
        x = x - radius
        y = y - radius
    end

    if __fill() then
        love.graphics.setColor(__fill():unpack())
        love.graphics.circle('fill', x, y, radius, SEGMENTS)
    end

    if __stroke() then
        love.graphics.setColor(__stroke():unpack())
        love.graphics.setLineWidth(strokeSize())
        love.graphics.circle('line', x, y, radius, SEGMENTS)
    end
end

function Graphics.ellipse(x, y, w, h)
    h = h or w

    if ellipseMode() == CORNER then
        x = x - w
        y = y - h
    end

    if __fill() then
        love.graphics.setColor(__fill():unpack())
        love.graphics.ellipse('fill', x, y, w/2, h/2, SEGMENTS)
    end

    if __stroke() then
        love.graphics.setColor(__stroke():unpack())
        love.graphics.setLineWidth(strokeSize())
        love.graphics.ellipse('line', x, y, w/2, h/2, SEGMENTS)
    end
end

function Graphics.plane(...)
    GraphicsCore.plane(...)
end

function Graphics.box(...)
    GraphicsCore.box(...)
end

function Graphics.pyramid(...)
    GraphicsCore.plane(...)
end

function Graphics.sphere(...)
    GraphicsCore.sphere(...)
end

function Graphics.drawMesh(mesh)
    love.graphics.draw(mesh.mesh or mesh)
end
