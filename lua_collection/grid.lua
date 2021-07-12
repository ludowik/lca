class 'Grid'

function Grid:init(w, h)
    self.size = w
    
    self.w = w
    self.h = h or w
    
    self.cells = table()
end

function Grid:clear()
    self.cells = table()
end

function Grid:offset(i, j)
    assert(i>=1 and i<=4)
    assert(j>=1 and j<=4)
    return i + (j-1) * self.size
end

function Grid:cell(i, j)
    local offset = self:offset(i, j)
    self.cells[offset] = self.cells[offset] or table()
    
    self.cells[offset].x = i
    self.cells[offset].y = j
    
    return self.cells[offset]
end

function Grid:set(i, j, value)
    local cell = self:cell(i, j)
    cell.value = value
end

function Grid:get(i, j)
    return self:cell(i, j).value
end

function Grid:ipairs()
    
end

function Grid:countCellsWithNoValue()
    local count = 0
    for j=1,self.size do
        for i=1,self.size do
            if self:get(i, j) == nil then
                count = count + 1
            end
        end
    end
    return count
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
            f(i, j, self:cell(i, j))
        end
    end
end
