function draw3d()    
    perspective()
    
    lookAt(vec3(3,3,3))

    if elapsedTime/5 % 3 <= 1 then
        rotate(elapsedTime, 1, 0, 0)
    else
        rotate(elapsedTime, 0, 1, 0)
    end
    
    fill(colors.white)

    local s = 1
    
--    box(0, 0, 0, s, s, s)
    sphere(0, 0, 0, s, s, s)
end

function drawInfo()    
    text(love.filesystem.getSaveDirectory())
    text(table.tolua(config))
    text(table.tolua({love.window.getSafeArea()}))
    text(table.tolua({mouse}))
end
