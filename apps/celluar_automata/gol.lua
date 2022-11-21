function setup()
    supportedOrientations(LANDSCAPE)

    CELLS_SIZE = floor(W/60)
    CELLS_COUNT = vec2(
        floor(W/CELLS_SIZE),
        floor(H/CELLS_SIZE))

    delay = 0

    grid = GolGrid(CELLS_COUNT.x, CELLS_COUNT.y)
    gridTemp = GolGrid(CELLS_COUNT.x, CELLS_COUNT.y)

    grid:reset()

    sizeCell = vec2(CELLS_SIZE, CELLS_SIZE)

    menu = ToolBar(cell2screen(1, 1))

    menu:add(Button('clear', function () grid:clear() end))
    menu:add(Button('reset', function () grid:reset() end))
    menu:add(Button('pause', function () grid:pause() end))
    menu:add(Button('resume', function () grid:resume() end))

    parameter.link('https://beltoforion.de/en/game_of_life/')
end

function cell2screen(i, j)
    return WIDTH / 10 * i, HEIGHT / 10 * j
end

function update(dt)
    grid:update(dt)
end

function draw()
    background(51)

    grid:draw()

    resetMatrix()

    menu:layout()
    menu:draw()
end

function touched(touch)
    if menu:contains(touch) then
        menu:touched(touch)
    else
        if touch.state == PRESSED and grid.status == 'active' then
            grid.status = 'suspended'
            
        elseif touch.state == RELEASED and grid.status == 'suspended' then
            grid.status = 'active'
        end
        
        local cell = grid:cellFromPosition(touch.x, touch.y)
        if cell then
            if grid.status ~= 'paused' then
                grid:addLife(cell.x, cell.y)
            else
                grid:setLife(cell.x, cell.y)
            end
        end
    end
end

class 'GolGrid' : extends(Grid)

function GolGrid:init(...)
    Grid.init(self, ...)
    self.status = 'active'
end

function GolGrid:reset()
    self:clear()

    for i=1,CELLS_COUNT.x do
        self:addLife()
    end

    self.size = vec2()
    self.position = vec2()
end

function GolGrid:pause()
    self.status = 'paused'
end

function GolGrid:resume()
    self.status = 'active'
end

function GolGrid:addLife(x, y)
    x = x or randomInt(CELLS_COUNT.x)
    y = y or randomInt(CELLS_COUNT.y)

    for i=1,6 do
        local dx = randomInt(-2, 2)
        local dy = randomInt(-2, 2)

        self:set(x+dx, y+dy, true)
    end
end

function GolGrid:setLife(x, y)
    x = x or randomInt(CELLS_COUNT.x)
    y = y or randomInt(CELLS_COUNT.y)

    self:set(x, y, not self:get(x, y))
end

function GolGrid:update(dt)
    if self.status ~= 'active' then return end

    delay = delay + dt

    if delay >= 0.08 then
        delay = 0
        for i,j,cell in self:ipairs() do
            local adjacent = (
                (self:get(i-1, j-1) == true and 1 or 0) +
                (self:get(i  , j-1) == true and 1 or 0) +
                (self:get(i+1, j-1) == true and 1 or 0) +

                (self:get(i-1, j  ) == true and 1 or 0) +
                (self:get(i+1, j  ) == true and 1 or 0) +

                (self:get(i-1, j+1) == true and 1 or 0) +
                (self:get(i  , j+1) == true and 1 or 0) +
                (self:get(i+1, j+1) == true and 1 or 0))

            local value = cell.value
            if value then
                if adjacent ~= 2 and adjacent ~= 3 then
                    value = false
                end
            else
                if adjacent == 3 then
                    value = true
                end
            end

            gridTemp:set(i, j, value)
        end

        grid, gridTemp = gridTemp, grid
    end
end

function GolGrid:draw()
    local w, h = sizeCell.x, sizeCell.y

    self.scale = 1

    self.size = vec2(
        grid.n * w * self.scale,
        grid.m * h * self.scale)

    self.position = vec2(
        (WIDTH  - self.size.x) / 2,
        (HEIGHT - self.size.y) / 2)

    local x = self.position.x
    local y = self.position.y

    translate(x, y)
    scale(self.scale, self.scale)

    stroke(colors.gray)
    strokeSize(0.5)

    for i=0,grid.n do
        line(w*i, 0, w*i, h*grid.m)
    end

    for j=0,grid.m do
        line(0, h*j, w*grid.n, h*j)
    end

    fill(colors.white)

    rectMode(CORNER)

    for i,j,cell in self:ipairs() do
        if cell.value then
            rect(w*(i-1), h*(j-1), w, h)
        end
    end
end

function GolGrid:cellFromPosition(x, y)
    x = x - self.position.x
    y = y - self.position.y

    if x >= 0 and y >= 0 and x < self.size.x and y < self.size.y then
        local i = math.ceil(x / (sizeCell.x * self.scale))
        local j = math.ceil(y / (sizeCell.y * self.scale))
        return self:cell(i, j)
    end
end
