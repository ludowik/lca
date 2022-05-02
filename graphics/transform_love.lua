local love2d = love

function resetMatrix()
    love2d.graphics.origin()
end

function pushMatrix()
    love2d.graphics.push()
end

function popMatrix()
    love2d.graphics.pop()
end

function translate(x, y, z)
    love2d.graphics.translate(x, y)
end

function scale(w, h, d)
    love2d.graphics.scale(w, h)
end

function rotate(angle, x, y, z)
    love2d.graphics.rotate(angle)
end
