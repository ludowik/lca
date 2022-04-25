function drawInfo()
    text(love.filesystem.getSaveDirectory())
    text(table.tolua(config))
    text(table.tolua({love.window.getSafeArea()}))
end
