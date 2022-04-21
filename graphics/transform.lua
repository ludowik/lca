local love2d = love
function resetMatrix()
    love2d.graphics.origin()
    love2d.graphics.translate(X, Y)    
end

function pushMatrix()
    love2d.graphics.push()
end

function popMatrix()
    love2d.graphics.pop()
end

function translate(x, y)
    love2d.graphics.translate(x, y)
end

function scale(w, h)
    love2d.graphics.scale(w, h)
end

function rotate(angle)
    love2d.graphics.rotate(angle)
end
