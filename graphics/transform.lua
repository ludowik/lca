local love2d = love

local matrices = {}
local model

function resetMatrix()
--    love2d.graphics.origin()
--    love2d.graphics.translate(X, Y)
    model = love.math.newTransform()
    model:translate(X, Y, 0)
    love.graphics.replaceTransform(model)
end

function pushMatrix()
--    love2d.graphics.push()
    table.insert(matrices, model)
    model = model:clone()    
    love.graphics.replaceTransform(model)
end

function popMatrix()
--    love2d.graphics.pop()
    model = table.remove(matrices)
    love.graphics.replaceTransform(model)
end

function translate(x, y, z)
--    love2d.graphics.translate(x, y)
    model:translate(x, y, z)
    love.graphics.replaceTransform(model)
end

function scale(w, h, d)
--    love2d.graphics.scale(w, h)
    model:scale(w, h, d)
    love.graphics.replaceTransform(model)
end

function rotate(angle)
--    love2d.graphics.rotate(angle)
    model:rotate(angle)
    love.graphics.replaceTransform(model)
end
