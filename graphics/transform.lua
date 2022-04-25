local love2d = love

local matrices = {}
local model

function resetMatrix()
    model = love.math.newTransform()
    model:translate(X, Y)
    love.graphics.replaceTransform(model)
--    love2d.graphics.origin()
--    love2d.graphics.translate(X, Y)
end

function pushMatrix()
--    love2d.graphics.push()
    table.insert(matrices, model)
    model = model:clone()    
end

function popMatrix()
--    love2d.graphics.pop()
    model = table.remove(matrices)
    love.graphics.replaceTransform(model)
end

function translate(x, y)
--    love2d.graphics.translate(x, y)
    model:translate(x, y)
    love.graphics.replaceTransform(model)
end

function scale(w, h)
--    love2d.graphics.scale(w, h)
    model:scale(w, h)
    love.graphics.replaceTransform(model)
end

function rotate(angle)
--    love2d.graphics.rotate(angle)
    model:rotate(angle)
    love.graphics.replaceTransform(model)
end
