function addCell()
    local countFreeCells = grid:countCellsWithValue(nil)
    if countFreeCells == 0 then
        state = 'game over'
        return
    end

    local i, j
    repeat
        i = love.math.random(4)
        j = love.math.random(4)
    until not grid:get(i, j)
    grid:set(i, j, table{2,2,4,2,2}:random())
end

function isGameOver()
    local cells = grid.cells:clone()
    local n = 0

    inGameOver = true

    for _,key in ipairs(commands) do
        n = n + action(key)
    end

    inGameOver = false

    grid.cells = cells
    return n == 0
end

function merge(i, j, di, dj)
    local value = grid:get(i, j)
    if value then
        local value2 = grid:get(i+di, j+dj)
        if value == value2 then
            grid:set(i, j, nil)
            grid:set(i+di, j+dj, value*2)
            if not inGameOver then
                score = score + value*2
                scoreMax = math.max(score, scoreMax)
            end
            return 1
        end
    end
    return 0
end

function mergeDown(i)
    local n = 0
    for j=3,1,-1 do
        n = n + merge(i, j, 0, 1)
    end
    return n
end

function mergeUp(i)
    local n = 0
    for j=2,4 do
        n = n + merge(i, j, 0, -1)
    end
    return n
end

function mergeLeft(j)
    local n = 0
    for i=2,4 do
        n = n + merge(i, j, -1, 0)
    end
    return n
end

function mergeRight(j)
    local n = 0
    for i=3,1,-1 do
        n = n + merge(i, j, 1, 0)
    end
    return n
end

function move(i, j, di, dj)
    local value = grid:get(i, j)
    if value then
        local value2 = grid:get(i+di, j+dj)
        if not value2 then
            grid:set(i, j, nil)
            grid:set(i+di, j+dj, value)
            return 1
        end
    end
    return 0
end

function moveDown(i)
    local n = 0    
    for j=3,1,-1 do
        for j2=j,3 do
            n = n + move(i, j2, 0, 1)
        end
    end
    return n
end

function moveUp(i)
    local n = 0
    for j=2,4 do
        for j2=j,2,-1 do
            n = n + move(i, j2, 0, -1)
        end
    end
    return n    
end

function moveLeft(j)
    local n = 0
    for i=2,4 do
        for i2=i,2,-1 do
            n = n + move(i2, j, -1, 0)
        end
    end
    return n    
end

function moveRight(j)
    local n = 0    
    for i=3,1,-1 do
        for i2=i,3 do
            n = n + move(i2, j, 1, 0)
        end
    end
    return n
end

function action(key)
    local n = 0        
    if key == 'down' then
        for i=1,4 do
            n = (n +
                moveDown(i) +
                mergeDown(i) +
                moveDown(i))
        end

    elseif key == 'up' then
        for i=1,4 do
            n = (n +
                moveUp(i) +
                mergeUp(i) +
                moveUp(i))
        end

    elseif key == 'left' then
        for j=1,4 do
            n = (n +
                moveLeft(j) +
                mergeLeft(j) +
                moveLeft(j)
            )
        end

    elseif key == 'right' then
        for j=1,4 do
            n = (n +
                moveRight(j) +
                mergeRight(j) +
                moveRight(j)
            )
        end
    end

    if n > 0 then
        addCell()
        if not inGameOver then
            save()
        end
    end

    return n
end

function save()
    local str = '{'..NL
    for i=1,grid.size*grid.size do
        if grid.cells[i] then
            str = str..'['..i..'] = '..grid.cells[i]..','
        end
    end
    str = str..NL..'    score = '..score..','
    str = str..NL..'    scoreMax = '..scoreMax..','
    str = str..NL..'}'

    love.filesystem.write('2048.data', str)
end

function load()
    local str = love.filesystem.read('2048.data')
    local data = loadstring('return '..str)()
    for i=1,grid.size*grid.size do
        grid.cells[i] = data[i]
    end
    score = data.score or 0
    scoreMax = data.scoreMax or 0
end
