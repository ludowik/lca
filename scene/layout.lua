class 'Layout'

function Layout.setup()
    Layout.outerMarge = 5
    Layout.innerMarge = 5
end

function Layout:clear()
    self.rowSize = nil
end

function Layout:computeNodeSize(node)
    node:computeSize()
    Layout.computeNodeFixedSize(self, node)
end

function Layout:computeNodeFixedSize(node)
    if node.fixedSize then
        node.size:set(
            node.fixedSize.x,
            node.fixedSize.y,
            0)

    elseif node.gridSize then
        node.size:set(
            ws(node.gridSize.x),
            hs(node.gridSize.y),
            0)
    end
end

function Layout:layout(mode, n, wmax)
    assert(wmax)
    wmax = wmax or W
    
    local outerMarge = self.outerMarge or (self.parent and self.parent.outerMarge or Layout.outerMarge)
    local innerMarge = self.innerMarge or (self.parent and self.parent.innerMarge or Layout.innerMarge)

    local position = vec2(outerMarge, outerMarge)
    local size = vec2()

    if not self.rowSize then
        self.rowSize = table()
        self.colSize = table()

        self.nodeSize = vec2()
    else
--        for _,size in ipairs(self.rowSize) do
--            size:set()
--        end

--        for _,size in ipairs(self.colSize) do
--            size:set()
--        end

--        self.nodeSize:set()
    end

    local i, j, k = 1, 1, 0
    for index=1,#self.nodes do
        local node = self.nodes[index]
        if node.visible ~= false then
            k = k + 1
            
            node.position.x = position.x
            node.position.y = position.y

            if node.nodes then
                node:layout(mode, n, wmax-position.x)
            else
                Layout.computeNodeSize(self, node)
            end

            self.colSize[i] = self.colSize[i] or vec2()
            self.rowSize[j] = self.rowSize[j] or vec2()

            self.colSize[i].x = max(self.colSize[i].x, node.size.x)
            self.colSize[i].y = max(self.colSize[i].y, node.size.y)

            self.rowSize[j].x = max(self.rowSize[j].x, node.size.x)
            self.rowSize[j].y = max(self.rowSize[j].y, node.size.y)

            self.nodeSize.x = max(self.nodeSize.x, node.size.x)
            self.nodeSize.y = max(self.nodeSize.y, node.size.y)

            if mode == 'row' then
                position.x = position.x + node.size.x + innerMarge
                i = i + 1

                if not node.nodes and k > 1 and position.x > wmax or node.newLine then
                    position.x = outerMarge
                    position.y = position.y + max(self.rowSize[j].y, node.size.y) + innerMarge

                    node.position.x = position.x
                    node.position.y = position.y

                    if not node.newLine then
                        position.x = position.x + node.size.x + innerMarge
                    end

                    i = 1
                    j = j + 1
                    
                    self.rowSize[j] = self.rowSize[j] or vec2()
                    self.rowSize[j].y = self.rowSize[j-1].y
                end

            elseif mode == 'column' then
                position.y = position.y + node.size.y + innerMarge
                j = j + 1

            elseif mode == 'grid' then
                node.size.x = self.nodeSize.x
                Layout.computeNodeFixedSize(self, node)

                if i == n then
                    position.x = outerMarge
                    i = 1

                    position.y = (position.y +
                        self.nodeSize.y +
                        innerMarge)
                    j = j + 1

                else
                    position.x = (position.x +
                        node.size.x +
                        innerMarge)
                    i = i + 1
                end
            end

            size.x = max(size.x, node.position.x + node.size.x + outerMarge)
            size.y = max(size.y, node.position.y + node.size.y + outerMarge)
        end
    end

    self.size = size
end

function Layout:row(_, wmax)
    return Layout.layout(self, 'row', nil, wmax or self.WMAX or W)
end

function Layout:column(_, wmax)
    return Layout.layout(self, 'column', nil, wmax or self.WMAX or W)
end

function Layout:topleft(_, wmax)
    return Layout.layout(self, 'topleft', nil, wmax or self.WMAX or W)
end

function Layout:grid(n, wmax)
    return Layout.layout(self, 'grid', n or self.n, wmax or self.WMAX or W)
end

function Layout:reverse()
    local h = self.parent == nil and H or self.parent.size.y
    self.position.y = h - self.position.y - self.size.y
    self.absolutePosition.y = H - self.absolutePosition.y - self.size.y

    if self.nodes and self.layoutFlow then
        for i,v in ipairs(self.nodes) do
            Layout.reverse(v)
        end
    end
end

function Layout:computeAbsolutePosition(x, y)
    x = x or self.position.x
    y = y or self.position.y

    self.absolutePosition = self.absolutePosition or vec2()
    self.absolutePosition.x = x
    self.absolutePosition.y = y

    if self.nodes and self.layoutFlow then
        for i,v in ipairs(self.nodes) do
            if v.position then
                Layout.computeAbsolutePosition(v,
                    x + v.position.x,
                    y + v.position.y)
            end
        end
    end
end

function Layout:align()
    if not self.alignment then return end

    local outerMarge = self.outerMarge or Layout.outerMarge
    local innerMarge = self.innerMarge or Layout.innerMarge

    self.position = vec2()

    local w, h
    if self.parent then
        w = self.parent.size.x
        h = self.parent.size.y
        w = w - outerMarge * 2
        h = h - outerMarge * 2
    else
        w = W
        h = H
    end

    local alignments = self.alignment:split(',')
    if alignments:findItem('center') or alignments:findItem('h-center') then
        self.position.x = self.position.x + (w - self.size.x) / 2
    end

    if alignments:findItem('center') or alignments:findItem('v-center') then
        self.position.y = self.position.y + (h - self.size.y) / 2
    end

    if alignments:findItem('right') then
        self.position.x = (w - self.size.x)
    end
end
