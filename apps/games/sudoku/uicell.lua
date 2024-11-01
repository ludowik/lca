class 'UI_cell' : extends(UI)

function UI_cell:init(grid, i, j)
    UI.init(self)

    self.i = i
    self.j = j

    self.im = quotient(i, grid.n)
    self.jm = quotient(j, grid.m)

    local size = min(ws(), hs())
    self.fixedSize = vec2(size, size)

    self.grid = grid
end

function UI_cell:draw()
    local grid = self.grid
    local ui_cellSelection = app.ui.numbers.ui_cell

    -- draw border
    style(s1, colors.gray, colors.white)

    rectMode(CORNER)
    rect(0, 0, self.size.x, self.size.y)

    -- draw helpers
    local clr = white
    if ui_cellSelection and
    (
        ui_cellSelection == self or
        ui_cellSelection.i == self.i or
        ui_cellSelection.j == self.j or
        (
            ui_cellSelection.im == self.im and
            ui_cellSelection.jm == self.jm
        )
    )
    then
        local marge = 3
        style(s1, colors.gray, colors.gray, LEFT)
        rect(marge, marge,
            self.size.x - marge * 2,
            self.size.y - marge * 2)
    end

    -- draw number
    local cell = grid:cell(self.i, self.j)

    if cell.value then
        local clr = cell.system and colors.blue or colors.green

        if not cell.numbers[cell.value] then
            clr = colors.red
        end

        local fontSize = hs(0.5)
        if ui_cellSelection then
            local cellSelection = grid:cell(ui_cellSelection.i, ui_cellSelection.j)
            if cell.value == cellSelection.value then
                fontSize = hs(0.65)
                style(s2, clr:mix(colors.red), transparent, CENTER)
                circle(
                    self.size.x/2, self.size.y/2,
                    fontSize)
            end
        end

        textStyle(fontSize, clr, CENTER)
        text(tostring(cell.value), self.size.x/2, self.size.y/2)
    end

    -- show possibilities
    if cell.numbers and app.showPossibilities then
        textStyle(8, colors.black, CORNER)
        local _,h = textSize('123456789')

        for i = 1, grid.n do
            if cell.numbers[i] then
                text(tostring(i), 7 * ( i - 1 ) + 2, self.size.x-h)
            end
        end
    end
end

function UI_cell:touched(touch)
    local cell = app.grid:cell(self.i, self.j)
    app.ui.numbers.ui_cell = self
end
