function resetMatrix()
    love.graphics.origin()
end

function pushMatrix()
    love.graphics.push()
end

function popMatrix()
    love.graphics.pop()
end

function translate(x, y)
    love.graphics.translate(x, y)
end

function rotate(a)
    love.graphics.rotate(a)
end
