function setup()
    commands = table{'down', 'up', 'left', 'right'}

    if W < H then
        cellSize = W / 4.4
    else
        cellSize = H / 8.8
    end

    scoreMax = 0

    newGrid()
end

function newGrid(new)
    state = 'play'
    grid = Grid2048(4)
    if new or not grid:load() then
        grid:addCell()
    end
end

function keyboard(key)
    if state == 'play' then
        if key:inList(commands) then
            log(key)

            grid:action(key)
            grid:save()

            if grid:isGameOver() then
                state = 'game over'
            end
            return
        end
    end

    if key == 'n' then
        newGrid(true)
    end

    if key == 't' then
        auto = not auto
    end
end

function wheelmoved(x, y)
    if x > math.abs(y) then
        keyboard('right')
    elseif x < -math.abs(y) then
        keyboard('left')
    elseif y > math.abs(x) then
        keyboard('down')
    elseif y < -math.abs(x) then
        keyboard('up')
    end
end

function touched(touch)
    if state == 'play' then
        if touch.state == RELEASED then
            wheelmoved(touch.tx, touch.ty)
        end
    else
        if touch.state == RELEASED and touch.y <= 100 then
            newGrid(true)
        end
    end
end

function update(dt)
    if auto then
        keyboard(table.random(commands))
    end
end

local bestSizeOfText = table()
function draw()
    background(51, 51, 51)

    fontName('Arial')

    textMode(CENTER)

    noStroke()

    local x, y = (W-cellSize*4)/2, cellSize*1.2
    local round = 4
    local innerMarge = 6
    local outerMarge = 12

    fill(colors[-1])
    rect(x-outerMarge, y-outerMarge, cellSize*4+outerMarge*2, cellSize*4+outerMarge*2, round)

    grid:applyFunction(
        function (i, j, value)
            local xc, yc = x+(i-1)*cellSize, y+(j-1)*cellSize

            if value then

                local clr = colors[value] or color(0.5)
                fill(clr)
                rect(xc+innerMarge/2, yc+innerMarge/2, cellSize-innerMarge, cellSize-innerMarge, round)

                if bestSizeOfText[value] then
                    fontSize(bestSizeOfText[value])
                else
                    local size = 10
                    while true do
                        fontSize(size)
                        local wt, ht = textSize(tostring(value))
                        if wt > cellSize*0.8 or ht > cellSize*0.6 then
                            break
                        end
                        size = size + 1
                    end
                    bestSizeOfText[value] = size
                end

                clr = clr:reverse():grayscale()
                textColor(clr)
                text(tostring(value), xc+cellSize/2, yc+cellSize/2)

            else
                local clr = colors[0]
                fill(clr)
                rect(xc+2, yc+2, cellSize-4, cellSize-4, round)
            end
        end)

    fontSize(22)

    textColor(white)

    text('SCORE'..NL..grid.score, cellSize*1.5, cellSize/2)
    text('BEST'..NL..scoreMax, cellSize*3.5, cellSize/2)

    if state == 'game over' then    
        fontName('Segoe')
        textMode(CENTER)

        fontSize(100)
        textColor(red)
        text('game over', W/2, H/2)
        fontSize(98)
        textColor(white)
        text('game over', W/2, H/2)
    end
end
