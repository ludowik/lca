function setup()
    app.commands = table{'down', 'up', 'left', 'right'}

    grid = newGrid()
    
    scoreMax = 0
    
    if W < H then
        cellSize = W / (grid.size+1)
    else
        cellSize = H / (grid.size+1)
    end
end

function newGrid(new)
    state = 'play'
    local grid = Grid2048(4)
    if new or not grid:load() then
        grid:addCell()
    end
    return grid
end

function keyboard(key)
    if state == 'play' then
        if key:inList(app.commands) then
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
        grid = newGrid(true)
    end
end

function action(x, y)
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
        if touch.state == RELEASED and gridRect:contains(touch.sx, touch.sy) then
            action(touch.tx, touch.ty)
        end
    else
        if touch.state == RELEASED and touch.y <= 100 then
            grid = newGrid(true)
        end
    end
end

function update(dt)
    if app.autotest then
        keyboard(table.random(commands))
    end
end

local bestSizeOfText = table()
function draw()
    background(51, 51, 51)

    fontName('Arial')

    textMode(CENTER)

    noStroke()

    local x, y = (W-cellSize*grid.size)/2, cellSize*1.2
    local round = 4
    local innerMarge = 6
    local outerMarge = 12
    
    gridRect = Rect(x-outerMarge, y-outerMarge, cellSize*grid.size+outerMarge*2, cellSize*grid.size+outerMarge*2)

    fill(colors[-1])
    rect(gridRect.position.x, gridRect.position.y, gridRect.size.w, gridRect.size.h, round)

    grid:applyFunction(
        function (i, j, cell)
            local xc, yc = x+(i-1)*cellSize, y+(j-1)*cellSize

            local value = cell.value
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
                fill(clr)
                text(tostring(value), xc+cellSize/2, yc+cellSize/2)

            else
                local clr = colors[0]
                fill(clr)
                rect(xc+2, yc+2, cellSize-round, cellSize-round, round)
            end
        end)

    fontSize(22)

    fill(white)

    text('SCORE'..NL..grid.score, W/4, cellSize/2)
    
    text('BEST'..NL..scoreMax, W*3/4, cellSize/2)

    if state == 'game over' then    
        textMode(CENTER)

        fontSize(100)
        fill(red)
        text('game over', W/2, H/2)
        fontSize(98)
        fill(white)
        text('game over', W/2, H/2)
    end
end
