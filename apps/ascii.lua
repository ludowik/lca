function setup()
    local source = Image('res/images/documents/marsu.jpeg')
    
    scaleFactor = 0.25
    img = source:scale(scaleFactor)

    parameter.integer('ww', 0, 8, 2)
    parameter.number('scaleFactor', 0.1, 0.8, 0.5, function (scale) img = source:scale(scaleFactor) end)
    
    parameter.boolean('grayScale', true)

    characters = defineCharactersSet()
end

function defineCharactersSet()
    fontName('Arial')
    fontSize(20)

    local sw, sh = 0, 0

    local code1, code2, step = 32, 48, 1
    for i=code1, code2, step do
        local character = string.char(i)
        local w, h = textSize(character)
        sw = max(w, sw)
        sh = max(h, sh)
    end

    local img = Image(sw, sh)
    local cx, cy = floor(sw/2), floor(sh/2)

    textMode(CENTER)
    textColor(colors.white)

    local characters = table()
    for i=code1, code2, step do
        local character = string.char(i)

        setContext(img)
        do
            background(colors.black)
            text(character, cx, cy)
        end
        setContext()

        local npixels = 0
        for x=0,sw-1 do
            for y=0,sh-1 do
                local r, g, b = img:get(x, y)
                if grayScale then
                    if r > 0 then
                        npixels = npixels + 1
                    end
                else
                    npixels = npixels + r
                end
            end
        end

        characters:add({
                character = character,
                npixels = npixels
            })
    end

    characters:sort(function (a, b)
            return a.npixels < b.npixels
        end)

    characters = characters:map(function (_, i, c) return c.character end)
    characters = characters:concat()

    assert(characters:sub(1,1) == ' ')
--    characters = ' .:-=+_?*#%@'

    log(characters)
    return characters
end

function draw()

    background(colors.black)

    spriteMode(CORNER)
    sprite(img, 0, 0)

    noStroke()

    local w = 2^ww
    fontSize(w)

    function drawImage(position, f, reverse)
        pushMatrix()
        translate(position.x, position.y)

        if not reverse then
            fill(colors.white)
        else
            fill(colors.black)
        end
        rect(0, 0, img.width, img.height)

        textMode(CENTER)

        for x=0,img.width,w do
            
            for y=0,img.height,w do
                
                local r, g, b, a = 0, 0, 0, 0, 0
                for dx=0,w-1 do
                    if x+dx >= img.width then break end
                    
                    for dy=0,w-1 do
                        if y+dy >= img.height then break end
                        
                        local r1, g1, b1, a1 = img:get(x+dx, y+dy)
                        r = r + r1
                        g = g + g1
                        b = b + b1
                        a = a + a1

                    end
                end

                local light = (r+g+g)/(3*w*w)
                f(position, light, reverse, x, y, w, h, r, g, b, a)
            end
        end
        popMatrix()
    end

    function ascii(position, light, reverse, x, y, w, h)
        local i = floor(map(light, 0, 1, 1, characters:len()))

        if not reverse then
            i = characters:len() -  i + 1
            textColor(colors.black)
            text(characters:sub(i, i), x+w/2, y+w/2)
        else
            textColor(colors.white)
            text(characters:sub(i, i), x+w/2, y+w/2)
        end
    end

    function pixel(position, light, reverse, x, y, w, h, r, g, b, a)
        fill((r+g+g)/(3*w*w))
        noStroke()
        rect(x, y, w, w)
    end

    drawImage(vec2(img.width, 0), ascii, false)
    drawImage(vec2(0, img.height), ascii, true)
    drawImage(vec2(img.width, img.height), pixel)

    sprite(lastCanvas, img.width, img.height)
end
