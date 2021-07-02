class 'Grid'

function Grid:init(size)
    self.size = size
    self.cells = table()
end

function Grid:offset(i, j)
    assert(i>=1 and i<=4)
    assert(j>=1 and j<=4)
    return i + (j-1) * self.size
end

function Grid:set(i, j, value)
    local offset = self:offset(i, j)
    self.cells[offset] = value
end

function Grid:get(i, j)
    local offset = self:offset(i, j)
    return self.cells[offset]
end

function Grid:countCellsWithValue(value)
    local count = 0
    for j=1,self.size do
        for i=1,self.size do
            if self:get(i, j) == value then
                count = count + 1
            end
        end
    end
    return count
end

function Grid:applyFunction(f)
    for j=1,self.size do
        for i=1,self.size do
            f(i, j, self:get(i, j))
        end
    end
end
