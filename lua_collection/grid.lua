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
    if (i>=1 and i<=4) and (j>=1 and j<=4) then
        return i + (j-1) * self.size
    end
    return -1
end

function Grid:cell(i, j)
    local offset = self:offset(i, j)
    if offset == -1 then return nil end

    self.cells[offset] = self.cells[offset] or table()

    self.cells[offset].x = i
    self.cells[offset].y = j

    return self.cells[offset]
end

function Grid:set(i, j, value)
    local cell = self:cell(i, j)
    if cell then
        cell.value = value
    end
end

function Grid:get(i, j)
    local cell = self:cell(i, j)
    if cell then
        return cell.value
    end
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
