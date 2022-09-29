class 'Node' : extends(Rect, table)

function Node:init()
    self:clear()
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
    self:setFocus(self.focus and self.focus.nextItem or self)
end

function Node:previousFocus()
    self:setFocus(self.focus and self.focus.previousItem or self)
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
    if self.hasFocus then return self end
    local nodes = self:items()
    for i,v in ipairs(nodes) do
        if v.getFocus then
            local who = v:getFocus()
            if who then
                return who
            end
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

function Node:setLayoutFlow(layoutFlow, layoutParam)
    self.layoutFlow = layoutFlow
    self.layoutParam = layoutParam
    return self
end

function Node:setAlignment(alignment)
    self.alignment = alignment
    return self
end

function Node:layout()
    if self.layoutFlow then
        self.layoutFlow(self, self.layoutParam)
--        Layout.align(self)
        Layout.computeAbsolutePosition(self)
    end
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
        local position = node.absolutePosition

        if position and node.items == nil then
            pushMatrix()
            translate(position.x, position.y)
        end

        if node.visible == nil or node.visible then
            node:draw()
        end

        if position and node.items == nil then
            popMatrix()
        end
    end    
end

function Node:touched(touch)
end
