function setup()
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

function autotest()
    fontNameIndex = randomInt(#fonts)
end

function update(dt)
end

function draw()
    background(51)

    textMode(CORNER)

    textPosition(0)

    local _, selectedFontName = splitFilePath(fonts[fontNameIndex])
    fontName(selectedFontName)    
    for i = 1,24 do
        fontSize(i)
        text(fontName()..' '..fontSize(), W/3)
    end

    local w, h

    textPosition(0)

    fontSize(12)

    stroke(colors.red)
    for i,v in ipairs(fonts) do
        local _, name = splitFilePath(v)
        fontName(name)

        if selectedFontName == name then
            textColor(colors.red)
        else
            textColor(colors.white)
        end
        
        local y = textPosition()
        w, h = text(fontName()..' '..fontSize())
    end

    textPosition(0)

    fontSize(24)
    fontName(selectedFontName)
    fill(colors.white)
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