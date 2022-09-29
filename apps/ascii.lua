function setup()
    img = Image('res/images/joconde.png')
    
    parameter.integer('ww', 1, 8, 4)
end

function draw()
    
    background()
    
    local characters = ' .:-=+_?*#%@'

    spriteMode(CORNER)
    sprite(img, 0, 0)

    noStroke()

    local w = 2^ww
    fontSize(w)
    
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
            
            textColor(colors.white)
            text(characters:sub(i, i), x+img.width, y)
        end
    end

end
