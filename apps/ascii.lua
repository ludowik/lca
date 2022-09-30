function setup()
    img = Image('res/images/joconde.png')

    parameter.integer('ww', 1, 8, 2)

    characters = defineCharactersSet()
end

function defineCharactersSet()
    fontName('Arial')
    fontSize(20)

    local sw, sh = 0, 0

    local code1, code2, step = 32, 127, 2
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
                if r > 0 then
                    npixels = npixels + 1
                end
--                npixels = npixels + r + g + b 
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

    function ascii(position, reverse)
        pushMatrix()
        translate(position.x, position.y)

        if not reverse then
            fill(colors.white)
        else
            fill(colors.black)
        end
        rect(0, 0, img.width, img.height)

        textMode(CENTER)

        for x=1,img.width-w,w do
            for y=1,img.height-w,w do
                local r, g, b = 0, 0, 0, 0
                for dx=0,w-1 do
                    for dy=0,w-1 do
                        local r1, g1, b1 = img:get(x+dx-1, y+dy-1)
                        r = r + r1
                        g = g + g1
                        b = b + b1

                    end
                end

                --            fill((r+g+g)/(3*w*w))
                --            rect(x+img.width, y, w, w)

                local light = (r+g+g)/(3*w*w)

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
        end
        popMatrix()
    end

    ascii(vec2(img.width, 0), false)
    ascii(vec2(0, img.height), true)

    sprite(lastCanvas, img.width, img.height)
end
