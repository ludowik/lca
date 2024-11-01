class 'Node' : extends(Rect, UI, table)

function Node:init(...)
    self:clear()
    self:setLayoutFlowFromParam(...)

    self.visible = true
end

function Node:clear()
    Rect.init(self)

    self.nodes = table()
    return self
end

function Node:items()
    return self.nodes
end

function Node:count()
    return #self.nodes
end

function Node:get(i)
    return self:items()[i]
end

function Node:add(...)
    self:addItems{...}
    return self
end

function Node:addItems(items)    
    for _,item in ipairs(items) do
        item.parent = self
        table.insert(self:items(), item)

        if item.setstyles then
            item:setstyles(self:root().styles)
        end

        assert(item.className ~= 'Scene')
    end
    return self
end

function Node:remove(i)
    self:items():remove(i)
    return self
end

function Node:removeItem(item)
    self:items():removeItem(item)
end

function Node:iter(reverse)
    return table.iterator(self:items(), reverse)
end

function Node:ui(label, level)
    level = level or 0

    local nodes = self:items()
    for i=1,#nodes do
        local node = nodes[i]
        if node.label == label then
            return node
        end
        if node.ui then
            local subView = node:ui(label, level+1)
            if subView then
                return subView
            end
        end
    end
end

function Node:root()
    local current = self
    while current.parent do
        current = current.parent
    end
    return current
end

function Node:contains(...)
    if self.visible == false then return end

    for i,v in ipairs(self.nodes) do
        if v.visible ~= false and v.contains then
            local res = v:contains(...)
            if res then
                return v
            end
        end
    end
end

function Node:nextFocus()
    if not self.focus then self:setFocus(self) return end

    local focus = self.focus.nextItem
    while focus and focus.visible == false do
        focus = focus.nextItem
    end

    self:setFocus(focus)
end

function Node:previousFocus()
    if not self.focus then self:setFocus(self) return end

    local focus = self.focus.previousItem
    while focus and focus.visible == false do
        focus = focus.previousItem
    end

    self:setFocus(focus)
end

function Node:setFocus(newFocus)
    if self.focus then
        self.focus.hasFocus = false
    end
    if newFocus then
        newFocus.hasFocus = true
    end
    self.focus = newFocus
end

function Node:getFocus()
    if self.focus then return self.focus end
    if self.hasFocus then return self end
    local nodes = self:items()
    for i,v in ipairs(nodes) do
        if v.getFocus then
            local who = v:getFocus()
            if who then
                return who
            end
        elseif v.hasFocus then
            return v
        end
    end
end

function Node:computeNavigation(previousUpNode, nextUpNode)
    if previousUpNode then
        previousUpNode.nextItem = self.nodes[1]
        nextUpNode.previousItem = self.nodes[#self.nodes]
    end

    for i=1,#self.nodes do
        local currentNode = self.nodes[i]
        local nextNode = self.nodes[i+1] or nextUpNode

        currentNode.previousItem, previousUpNode = previousUpNode, currentNode

        currentNode.parent = self

        if currentNode.nodes and #currentNode.nodes > 0 then
            currentNode:computeNavigation(currentNode, nextNode)
        else
            currentNode.nextItem = nextNode
        end
    end
end

function Node:setLayoutFlowFromParam(...)
    local label, layoutFlow, layoutParam

    local args = {...}
    if #args == 1 then
        if type(args[1]) == 'string' then
            label = ...
        else
            layoutFlow = ...
        end

    elseif #args == 2 then
        if type(args[1]) == 'string' then
            label, layoutFlow = ...
        else
            layoutFlow, layoutParam = ...
        end

    elseif #args == 3 then
        label, layoutFlow, layoutParam = ...
    end

    assert(label == nil or type(label) == 'string')
    assert(layoutFlow == nil or type(layoutFlow) == 'function')
    assert(layoutParam == nil or type(layoutParam) == 'number')

    if layoutFlow then
        self:setLayoutFlow(layoutFlow, layoutParam)
    end
end

function Node:setLayoutFlow(layoutFlow, layoutParam)
    self.layoutFlow = layoutFlow
    self.layoutParam = layoutParam
    return self
end

function Node:setAlignment(alignment)
    self.alignment = alignment
    return self
end

function Node:layout(_, _, wmax)
    if self.layoutFlow then
        self.layoutFlow(self, self.layoutParam, wmax)
        --        Layout.align(self)
        --        Layout.computeAbsolutePosition(self)

        --        if self.origin == BOTTOM_LEFT then
        --            Layout.reverse(self)
        --        end
    end
end

function Node:computeSize()
end

function Node:setGridSize(n, m)
    self.gridSize = vec2(n, m)
end

function Node:update(dt)
    local items = self:items()
    for i=1,#items do
        local item = items[i]
        if item.update then
            item:update(dt)
        end
    end
end

function Node:draw()
    local nodes = self:items()
    for i,node in ipairs(nodes) do
        if node.visible ~= false and node.draw then
            local position = node.absolutePosition or node.position

            if position and node.items == nil then
                pushMatrix()
                translate(position.x, position.y)

                if node.angle then
                    rotate(node.angle)
                end
            end

            node:draw()

            if position and node.items == nil then
                popMatrix()
            end
        end
    end    
end

function Node:touched(touch)
    local x, y = 0, 0
    local nodes = self:items()
    for i,node in ipairs(nodes) do
        if node:contains(touch) then
            node:touched(touch)
            return true
        end
    end
end

function Node:wheelmoved(dx, dy)
    local x, y = love.mouse.getPosition()
    x = x - X
    y = y - Y

    local nodes = self:items()
    for i,node in ipairs(nodes) do
        if node:contains(vec2(x, y)) then
            node:wheelmoved(dx, dy)
            break
        end
    end
end
