function setup()    
    cells = Grid(3)

    cells.state = 'play'

    if W < H then
        cells.cellSize = W / 4
    else
        cells.cellSize = H / 4
    end

    player = 'x'

    players = {
        x = {type='player'},
        o = {type='ia'}
    }

    scores = {
        x = 0,
        o = 0,
        n = 0,
    }

    parameter.watch('x', "scores['x']")
    parameter.watch('o', "scores['o']")

    parameter.watch('nul', "scores['n']")

    parameter.integer('depth', 1, 10, 6)

    minimax = Minimax(cells)
end

function draw()
    background(54)

    cells:applyFunction(drawCell)
end

function update(dt)
    players['x'].type = env.__autotest and 'ia' or 'player'

    if cells.state == 'play' then
        local winner = minimax:gameWin(cells)
        if winner then
            cells.state = 'win'
            scores[winner] = scores[winner] + 1

        else
            if minimax:gameEnd(cells) then
                cells.state = 'end'
                scores['n'] = scores['n'] + 1

            elseif players[player].type == 'ia' then
                local cell = minimax:gamePlay(cells, player)
                cell.value = player
                player = minimax:nextPlayer(player)
            end
        end

    elseif cells.state == 'end' or cells.state == 'win' then
        cells:clear()
        cells.state = 'play'
    end
end

class 'Minimax'

function Minimax:init(grid)
    self.WIN_VALUE = 100

    self.lines = table()

    for i=1,grid.n do
        self.lines:add({i, 1, 0, 1})
    end

    for i=1,grid.m do
        self.lines:add({1, i, 1, 0})
    end

    self.lines:add({1, 1, 1, 1})
    self.lines:add({1, grid.m, 1, -1})
end

function Minimax:nextPlayer(player)
    return player == 'x' and 'o' or 'x'
end

local MIN, MAX = math.mininteger, math.maxinteger

function Minimax:minimax(grid, depth, maximizingPlayer, currentPlayer, alpha, beta)
    local winner = self:gameWin(grid)
    if winner then
        return self.WIN_VALUE * (maximizingPlayer and -1 or 1)
    end

    local moves = self:gameMoves(grid)
    local n = #moves

    if depth == 0 or n == 0 then
        return random(self.WIN_VALUE/10) * (maximizingPlayer and -1 or 1)
    end

    local move, op, bestValue
    if maximizingPlayer then
        bestValue = MIN
        op = math.max
    else
        bestValue = MAX
        op = math.min
    end

    for i=1,n do
        move = moves[i]

        grid:set(move.x, move.y, currentPlayer)

        local value = self:minimax(grid, depth-1, not maximizingPlayer, self:nextPlayer(currentPlayer), alpha, beta)

        if op(value, bestValue) == value then
            bestValue = value
        end

        if maximizingPlayer then
            alpha = op(alpha, bestValue)
        else
            beta = op(beta, bestValue)
        end

        grid:set(move.x, move.y)

        if beta <= alpha then
            break
        end
    end

    return bestValue
end

function Minimax:gamePlay(grid, player)
    local moves = self:gameMoves(grid)
    local n = #moves

    local bestMove

    local bestValue = math.mininteger
    for i=1,n do
        move = moves[i]

        grid:set(move.x, move.y, player)

        local value = self:minimax(grid, depth, false, self:nextPlayer(player), MIN, MAX)
        if value > bestValue then
            bestValue = value
            bestMove = move
        end

        grid:set(move.x, move.y)
    end

    return grid:cell(bestMove.x, bestMove.y)
end

function Minimax:gameMoves(grid)
    local moves = table()
    grid:applyFunction(function (i,j,cell)
            if not cell.value then 
                moves:add(cell)
            end
        end)
    return moves
end

local function testLine(grid, line)
    local x, y, dx, dy = unpack(line)

    local cell = grid:cell(x, y)

    local value = cell and cell.value
    if not value then
        return false
    end

    while cell do
        x = x + dx
        y = y + dy

        cell = grid:cell(x, y)

        if cell and (
            cell.value == nil or
            cell.value ~= value
        )
        then
            return false
        end
    end

    return value
end

function Minimax:gameWin(grid)    
    for _,line in ipairs(self.lines) do
        local winner = testLine(grid, line)
        if winner then
            return winner
        end
    end
end

function Minimax:gameEnd(grid)
    if grid:countCellsWithNoValue() == 0 then
        return true
    end
end

function drawCell(x, y, cell)
    local w = cells.cellSize / 3
    local value = cell.value

    pushMatrix()
    do
        local x = (x-1)*cells.cellSize + cells.cellSize
        local y = (y-1)*cells.cellSize + cells.cellSize

        translate(x, y)

        strokeSize(1)
        stroke(colors.white)

        noFill()

        rectMode(CENTER)
        rect(0, 0, cells.cellSize, cells.cellSize)

        strokeSize(8)

        if value == 'x' then
            stroke(colors.red)
            line(-w, -w,  w,  w)
            line(-w,  w,  w, -w)

        elseif value == 'o' then
            stroke(colors.green)
            circleMode(CENTER)
            circle(0, 0, w)
        end
    end
    popMatrix()
end

function touched(touch)
    if touch.state ~= RELEASED then return end

    if players[player].type == 'player' then
        if cells.state == 'play' then
            local x = cells.cellSize / 2
            local y = cells.cellSize / 2

            local dx, dy = cells.cellSize, cells.cellSize

            local ix = math.floor((touch.x - x) / dx) + 1
            local iy = math.floor((touch.y - y) / dy) + 1

            local cell = cells:cell(ix, iy)

            if cell and not cell.value then
                cell.value = player
                player = minimax:nextPlayer(player)
            end
        end
    end
end