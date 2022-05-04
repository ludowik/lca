local Collision = class('Fizix.Collision')

function Collision.collide(obj1, obj2)
    if obj1.shapeType == POLYGON and obj2.shapeType == POLYGON then
--        return Collision.rect2rect(obj1, obj2)
        return box2dIntersectBox2d(obj1:getBox2d(), obj2:getBox2d())

    elseif obj1.shapeType == POLYGON and obj2.shapeType == CIRCLE then
        return Collision.circle2rect(obj2, obj1)

    elseif obj1.shapeType == CIRCLE and obj2.shapeType == POLYGON then
        return Collision.circle2rect(obj1, obj2)

    else
        return Collision.circle2circle(obj1, obj2)
    end
end

function Collision.rect2rect(obj1, obj2)
    local xl1, yb1, xr1, yt1 = obj1:getBoundingBox()
    local xl2, yb2, xr2, yt2 = obj2:getBoundingBox()

    if xr1 < xl2 or xl1 > xr2 or yt1 < yb2 or yb1 > yt2 then
        return false
    end

    return true
end

function Collision.circle2circle(obj1, obj2)
    local x1, y1, r1 = obj1:getBoundingCircle()
    local x2, y2, r2 = obj2:getBoundingCircle()

    if math.sqrt((x2-x1)^2+(y2-y1)^2) > r1+r2 then
        return false
    end

    return true
end

function Collision.circle2rect(obj1, obj2)
    local x1, y1, r1 = obj1:getBoundingCircle()
    local xl2, yb2, xr2, yt2 = obj2:getBoundingBox()

    if x1 < xl2-r1 or x1 > xr2 +r1 or y1 < yb2-r1 or y1 > yt2+r1 then
        return false
    end

    return true
end


