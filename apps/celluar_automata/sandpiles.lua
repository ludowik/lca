function setup()
    size = 600
    img = Image(size)

    sandpiles = {}
    nextpiles = {}
    for i=1,size do
        sandpiles[i] = {}
        nextpiles[i] = {}
        for j=1,size do
            sandpiles[i][j] = 0
            nextpiles[i][j] = 0
        end
    end

    sandpiles[size/2][size/2] = 1000000
end

function update()
    for i=1,15 do
        updatePiles()
    end
end

function updatePiles()
    for i=1,size do
        for j=1,size do
            nextpiles[i][j] = 0
        end
    end

    for x=1,size do
        for y=1,size do
            num = sandpiles[x][y]
            if num <= 3 then
                nextpiles[x][y] = sandpiles[x][y]
            end
        end
    end

    local num
    for x=1,size do
        for y=1,size do
            num = sandpiles[x][y]
            if num > 3 then
                nextpiles[x][y] = nextpiles[x][y] + num - 4
                if nextpiles[x+1] then
                    nextpiles[x+1][y] = nextpiles[x+1][y] + 1
                end

                if nextpiles[x-1] then
                    nextpiles[x-1][y] = nextpiles[x-1][y] + 1
                end

                if nextpiles[x][y+1] then
                    nextpiles[x][y+1] = nextpiles[x][y+1] + 1
                end

                if nextpiles[x][y-1] then
                    nextpiles[x][y-1] = nextpiles[x][y-1] + 1
                end
            end
        end
    end

    nextpiles, sandpiles = sandpiles, nextpiles
end

function draw()
    img.imageData:mapPixel(function (x, y, r, g, b, a)
            local clr
            local row, num
            
            row = sandpiles[x+1]
            num = row[y+1]

            clr = colors.white
            if num == 1 then
                clr = colors.red
            elseif num == 2 then
                clr = colors.green
            elseif num == 3 then
                clr = colors.blue
            elseif num > 3 then
                clr = colors.gray
            end

            return clr.r, clr.g, clr.b, 1
        end)

    translate(W/2, H/2)
    sprite(img)
end