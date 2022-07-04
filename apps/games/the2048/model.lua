class 'Grid2048' : extends(Grid)

function Grid2048:init(size)
    Grid.init(self, size, size)
    
    self.size = size
    self.score = 0
end

function Grid2048:addCell()
    local countFreeCells = self:countCellsWithValue(nil)
    if countFreeCells == 0 then
        state = 'game over'
        return
    end

    local i, j
    repeat
        i = randomInt(self.size)
        j = randomInt(self.size)
    until not self:get(i, j)
    self:set(i, j, table{2,2,4,2,2}:random())
end

function Grid2048:isGameOver()
    local grid = Grid2048(self.n, self.m)
    grid.cells = self.cells:clone()

    local n = 0
    for _,key in ipairs(commands) do
        n = n + grid:action(key)
    end

    return n == 0
end

function Grid2048:merge(i, j, di, dj)
    local value = self:get(i, j)
    if value then
        local value2 = self:get(i+di, j+dj)
        if value == value2 then
            self:set(i, j, nil)
            self:set(i+di, j+dj, value*2)
            self.score = self.score + value*2
            return 1
        end
    end
    return 0
end

function Grid2048:mergeDown(i)
    local n = 0
    for j=self.size-1,1,-1 do
        n = n + self:merge(i, j, 0, 1)
    end
    return n
end

function Grid2048:mergeUp(i)
    local n = 0
    for j=2,self.size do
        n = n + self:merge(i, j, 0, -1)
    end
    return n
end

function Grid2048:mergeLeft(j)
    local n = 0
    for i=2,self.size do
        n = n + self:merge(i, j, -1, 0)
    end
    return n
end

function Grid2048:mergeRight(j)
    local n = 0
    for i=self.size-1,1,-1 do
        n = n + self:merge(i, j, 1, 0)
    end
    return n
end

function Grid2048:move(i, j, di, dj)
    local value = self:get(i, j)
    if value then
        local value2 = self:get(i+di, j+dj)
        if not value2 then
            self:set(i, j, nil)
            self:set(i+di, j+dj, value)
            return 1
        end
    end
    return 0
end

function Grid2048:moveDown(i)
    local n = 0    
    for j=self.size-1,1,-1 do
        for j2=j,self.size-1 do
            n = n + self:move(i, j2, 0, 1)
        end
    end
    return n
end

function Grid2048:moveUp(i)
    local n = 0
    for j=2,self.size do
        for j2=j,2,-1 do
            n = n + self:move(i, j2, 0, -1)
        end
    end
    return n    
end

function Grid2048:moveLeft(j)
    local n = 0
    for i=2,self.size do
        for i2=i,2,-1 do
            n = n + self:move(i2, j, -1, 0)
        end
    end
    return n    
end

function Grid2048:moveRight(j)
    local n = 0    
    for i=self.size-1,1,-1 do
        for i2=i,self.size-1 do
            n = n + self:move(i2, j, 1, 0)
        end
    end
    return n
end

function Grid2048:action(key)
    local n = 0        
    if key == 'down' then
        for i=1,self.size do
            n = (n +
                self:moveDown(i) +
                self:mergeDown(i) +
                self:moveDown(i))
        end

    elseif key == 'up' then
        for i=1,self.size do
            n = (n +
                self:moveUp(i) +
                self:mergeUp(i) +
                self:moveUp(i))
        end

    elseif key == 'left' then
        for j=1,self.size do
            n = (n +
                self:moveLeft(j) +
                self:mergeLeft(j) +
                self:moveLeft(j)
            )
        end

    elseif key == 'right' then
        for j=1,self.size do
            n = (n +
                self:moveRight(j) +
                self:mergeRight(j) +
                self:moveRight(j)
            )
        end
    end

    scoreMax = math.max(self.score, scoreMax)

    if n > 0 then
        self:addCell()
    end

    return n
end

function Grid2048:save()
    local str = '{'..NL

    self:applyFunction(function (i, j, cell)
            if cell and cell.value then
                str = str..'    {i='..i..', j='..j..', value='..cell.value..'},'..NL
            end
    end)

    str = str..NL..'    score = '..self.score..','
    str = str..NL..'    scoreMax = '..scoreMax..','
    str = str..NL..'}'

    return io.write(env.appName:replace('/', '.')..'.mydata', str)
end

function Grid2048:load()
    local str = io.read(env.appName:replace('/', '.')..'.mydata')
    if str then
        local data = loadstring('return '..str)()
        if data then
            for i,cell in ipairs(data) do
                self:set(cell.i, cell.j, cell.value)
            end
            
            self.score = data.score or 0
            scoreMax = data.scoreMax or 0

            return true
        end
    end
    return false, 'no file'
end
