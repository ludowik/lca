class 'UI_grid' : extends(UINode)

function UI_grid:init(grid, ...)
    UINode.init(self, ...)

    self.grid = grid

    self:setLayoutFlow(Layout.row)

    self.outerMarge = 0
    self.innerMarge = 0

    for j = 1, grid.m do
        local ui_line = UINode(Layout.column)

        ui_line.outerMarge = 0
        ui_line.innerMarge = 0

        self:add(ui_line)

        for i = 1, grid.n do
            ui_line:add(UI_cell(grid, i, j))
        end
    end
end

function UI_grid:draw()
    UINode.draw(self)

    local ui_cell = self.nodes[1].nodes[1]
    style(s3, colors.brown, colors.transparent, LEFT)

    rectMode(CORNER)
    
    translate(self.position.x, self.position.y)

    for i = 0, 2 do
        for j = 0, 2 do
            rect(
                ui_cell.size.x * 3 * i,
                ui_cell.size.y * 3 * j,
                ui_cell.size.x * 3,
                ui_cell.size.y * 3)
        end
    end
end
