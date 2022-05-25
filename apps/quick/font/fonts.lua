function setup()
--    setFontPath('/System/Library/Fonts')

    fonts = dir(getFontPath())
    fontNameIndex = 1

    size = 12

    alphabet = ''
    for i=32,127 do
        if i%size == 0 and #alphabet > 0 then
            alphabet = alphabet..NL
        end
        alphabet = alphabet..string.char(i)
    end
end

function draw()
    background(51)

    textMode(CORNER)

    textPosition(0)

--    fontNameIndex = randomInt(#fonts)

    local _, fontNameRandom = splitFilePath(fonts[fontNameIndex])
    fontName(fontNameRandom)    
    for i = 1,24 do
        fontSize(i)
        text(fontName()..' '..fontSize(), W/3)
    end

    local w, h

    textPosition(0)

    fontSize(12)
    
    stroke(red)
    for i,v in ipairs(fonts) do
        local _, name = splitFilePath(v)
        fontName(name)

        fill(white)

        w, h = text(fontName()..' '..fontSize())

        if fontNameRandom == name then
            noFill()
            rect(0, textPosition(), w, h)
        end
    end

    textPosition(0)
    
    fontSize(24)
    fontName(fontNameRandom)
    fill(white)
    text(alphabet, W*2/3)
end

function keyboard(key)
    if key == 'down' then
        fontNameIndex = (fontNameIndex + 1) % #fonts
    elseif key == 'up' then
        fontNameIndex = (fontNameIndex - 1) % #fonts
    end

    if fontNameIndex > #fonts then 
        fontNameIndex = 1
    elseif fontNameIndex < 1 then
        fontNameIndex = #fonts
    end
end
