function setup()
    commands = table{'down', 'up', 'left', 'right'}

    state = 'play'

    cellSize = 80

    score = 0
    scoreMax = 0

    grid = Grid(4)
--    addCell()

    load()
end

function keyboard(key)
    if state == 'play' then
        if key:inList(commands) then
            action(key)
            if isGameOver() then
                state = 'game over'
            end

        elseif key == 'n' then
            grid = Grid(4)
            score = 0
            addCell()
        end
    end
end

function update(dt)
--    keyboard(table.random(commands))
end

local bestSizeOfText = table()
function draw()
    background()

    if state == 'play' then
        fontName('Arial')

        textMode(CENTER)
        
        noStroke()

        fill(colors[-1])
        rect(cellSize-10, cellSize-10, cellSize*4+20, cellSize*4+20, 10)

        grid:applyFunction(
            function (i, j, value)
                local x, y = i*cellSize, j*cellSize

                if value then

                    local clr = colors[value] or color(0.5)
                    fill(clr)
                    rect(x+2, y+2, cellSize-4, cellSize-4, 10)

                    if bestSizeOfText[value] then
                        fontSize(bestSizeOfText[value])
                    else
                        local size = 10
                        while true do
                            fontSize(size)
                            local wt, ht = textSize(tostring(value))
                            if wt > cellSize*0.8 or ht > cellSize*0.8 then
                                break
                            end
                            size = size + 1
                        end
                        bestSizeOfText[value] = size
                    end

                    clr = color.reverse(clr)
                    fill(clr)
                    text(tostring(value), x+cellSize/2, y+cellSize/2)

                else
                    local clr = colors[0]
                    fill(clr)
                    rect(x+2, y+2, cellSize-4, cellSize-4, 10)
                end
            end)

        fill(white)
        
        fontSize(22)
        
        text(score, cellSize*2, cellSize/2)
        text(scoreMax, cellSize*4, cellSize/2)

    else
        fontName('Segoe')
        fontSize(50)

        textMode(CENTER)
        text('game over', W/2, H/2)
    end
end
