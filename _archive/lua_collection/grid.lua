class 'Grid'

function Grid:init(w, h)
    assert(w)
    
    self.w = w
    self.h = h or w

    self.cells = table()
end

function Grid:clear()
    self.cells = table()
end

function Grid:randomCell()
    local x = randomInt(1, self.w)
    local y = randomInt(1, self.h)
    return self:cell(x, y)
end

function Grid:offset(i, j)
    if (i>=1 and i<=self.w) and (j>=1 and j<=self.h) then
        return i + (j-1) * self.w
    end
    return -1
end

function Grid:cell(i, j)
    local offset = self:offset(i, j)
    if offset == -1 then return nil end

    self.cells[offset] = self.cells[offset] or self:newCell(i, j) -- table()

    self.cells[offset].x = i
    self.cells[offset].y = j

    return self.cells[offset]
end

function Grid:newCell(i, j, value)
    return table()
end

function Grid:get(i, j)
    local cell = self:cell(i, j)
    if cell then
        return cell.value
    end
end

function Grid:set(i, j, value)
    local cell = self:cell(i, j)
    if cell then
        cell.value = value
    end
end

function Grid:countCellsWithNoValue()
    local count = 0
    for j=1,self.h do
        for i=1,self.w do
            if self:get(i, j) == nil then
                count = count + 1
            end
        end
    end
    return count
end

function Grid:countCellsWithValue(value)
    local count = 0
    for j=1,self.h do
        for i=1,self.w do
            if self:get(i, j) == value then
                count = count + 1
            end
        end
    end
    return count
end

function Grid:applyFunction(f)
    for j=1,self.h do
        for i=1,self.w do
            f(i, j, self:cell(i, j))
        end
    end
end

function Grid:ipairs()
    local x = 0
    local y = 1

    return function ()
        x = x + 1
        if x > self.w then
            x = 1
            y = y + 1
        end
        if y > self.h then
            return nil
        end
        return x, y, self:cell(x, y)
    end
end

function Grid:draw(draw)
    for x=1,self.w do
        for y=1,self.h do
            draw(x, y, self:get(x, y))
        end
    end
end

function Grid:rotate()
    local array = Grid(self.h, self.w)
    for i=1,self.w do
        for j=1,self.h do
            array:set(i, j, self:get(j, self.h-i+1))
        end
    end
    return array
end

function Grid:duplicate()
    local array = Grid(self.w, self.h, self.defaultValue)

    for i=1,array.w do
        for j=1,array.h do
            local value = self:get(i, j)
            if value then
                array:set(i, j, value)
            end
        end
    end

    return array
end

function Grid:copy(array, xt, yt)
    for i=1,array.w do
        for j=1,array.h do
            local value = array:get(i, j)
            if value then
                self:set(xt+i-1, yt+j-1, value)
            end
        end
    end
end

function Grid:save()
    local str = '{'..NL

    self:applyFunction(function (i, j, cell)
            if cell and cell.value then
                str = str..'    {i='..i..', j='..j..', value='..cell.value..'},'..NL
            end
    end)

    str = str..NL..'}'

    return io.write(app.appName:replace('/', '.')..'.mygrid', str)
end

function Grid:load()
    local str = io.read(app.appName:replace('/', '.')..'.mygrid')
    if str then
        local data = loadstring('return '..str)()
        if data then
            for i,cell in ipairs(data) do
                self:set(cell.i, cell.j, cell.value)
            end

            return true
        end
    end
    return false, 'no file'
end

function Grid:asText()
    local text = string.rep('-', self.w)..NL
    for x,y,cell in self:ipairs() do
        text = text..(cell.value or ' ')
        if x == self.w and y ~= self.h then
            text = text..NL
        end
    end
    return text
end

function Grid.test()
    local grid = Grid(10)
    grid:set(1, 1, 12)
    assert(grid:get(1, 1) == 12)
end
