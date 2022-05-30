class 'Node' : extends(Rect)

function Node:init()
    self:clear()
end

function Node:clear()
    Rect.init(self)

    self.nodes = table()

    return self
end

function Node:setLayoutFlow()
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
    self:items():addItems{...}
    return self
end

function Node:addItems(items)
    self:items():addItems(items)
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
    -- TODO reverse
    return ipairs(self:items())
end

function Node:update(dt)
    for i,v in self:iter() do
        if v.update then
            v:update(dt)
        end
    end
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
    self:setFocus(self.focus and self.focus.next or self)
end

function Node:previousFocus()
    self:setFocus(self.focus and self.focus.previous or self)
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
    if self.focus then return self end
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
    previousUpNode.next = self.nodes[1]
    nextUpNode.previous = self.nodes[#self.nodes]

    for i=1,#self.nodes do
        local currentNode = self.nodes[i]
        local nextNode = self.nodes[i+1] or nextUpNode

        currentNode.previous, previousUpNode = previousUpNode, currentNode
        
        currentNode.parent = self

        if currentNode.nodes and #currentNode.nodes > 0 then
            currentNode:computeNavigation(currentNode, nextNode)
        else
            currentNode.next = nextNode
        end
    end
end

function Node:layout()
    if self.layoutFlow then
        self.layoutFlow(self, self.layoutParam)
    end
end

function Node:update(dt)
    local items = self:items()
    for i=1,#items do
        local item = items[i]
        assert(item.update, item.__className)
        item:update(dt)
    end
end

function Node:draw()
    local items = self:items()
    for i=1,#items do
        local item = items[i]
        item:draw()
    end
end
