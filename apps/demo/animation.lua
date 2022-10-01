function setup()
    parameter.integer('config.framerate', 1, 200, 30)

    atlas = Image('res/images/sheep.jpg')    

    function loadSprites(img, ws, hs, n, x, y, ms)
        ms = ms or 0
        
        x = x or 0
        y = y or img.height
        
        ws = ws or 1
        hs = hs or 1

        animation = {
            ws = ws,
            hs = hs
        }

        local line = 1

        local index = 0
        for i=1,n do
            animation[#animation+1] = atlas:copy(x + ms + ws * index, y - line * hs, ws, hs)

--            fillFromPosition(animation[#animation])

            index = index + 1
            if ms + ws * index + ws > img.width then
                line = line + 1
                index = 0
            end
        end

        return animation
    end

    parameter.integer('xx', 0, atlas.height, 20, function ()
            animation = loadSprites(atlas, ww, hh, 6, xx, yy)
        end)
    parameter.integer('yy', 0, atlas.height, 140, function ()
            animation = loadSprites(atlas, ww, hh, 6, xx, yy)
        end)
    parameter.integer('ww', 0, atlas.height, 101, function ()
            animation = loadSprites(atlas, ww, hh, 6, xx, yy)
        end)
    parameter.integer('hh', 0, atlas.height, 84, function ()
            animation = loadSprites(atlas, ww, hh, 6, xx, yy)
        end)

    animation = loadSprites(atlas, ww, hh, 6, xx, yy)
    
    n = 0
end

function fillFromPosition(self, x, y)
    x, y = x or 1, y or 1
    local w, h = self.width, self.height

    local fromColor = self:get(x, y)
    function propagation(x, y)
        if self:get(x, y) > 0.9 then
            self:set(x, y, Color(0, 0, 0, 0))
            if x < w-1 then
                propagation(x+1, y)
            end
            if y < h-1 then
                propagation(x, y+1)
            end
            if x > 0 then
                propagation(x-1, y)
            end
            if y > 0 then
                propagation(x, y-1)
            end
        end
    end
    propagation(x, y)
end

function update(dt)
end

function draw(dt)
    background(51)

    resetMatrix()

    rectMode(CORNER)
    spriteMode(CORNER)
    stroke(colors.red)
    noFill()

    n = (n + deltaTime*10)
    sprite(animation[floor(n)%#animation+1], 0, 0)

    local dx = 0
    for i=1,#animation   do
        sprite(animation[i], dx, 200)
        rect(dx, 200, animation[i].width, animation[i].height)
        dx = dx + animation[i].width
    end

    sprite(atlas, 0, 400, 400, 400)
end
