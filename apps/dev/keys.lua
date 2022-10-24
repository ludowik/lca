function draw()
    background()

    local n = Engine.keys:getnKeys()

    local size = H * 0.8 / n
    fontSize(size)
    
    textPosition(size)
    textMode(CORNER)
    
    for k,v in pairs(Engine.keys) do
        text(k..': '..v.desc, 100)
    end
end
