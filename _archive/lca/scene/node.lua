class 'Node' : extends(Rect)

function Node:init()
    Rect.init(self)
    self:clear()
end

function Node:clear()
    self.nodes = table()
    return self
end

function Node:items()
    return self.nodes
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

function Node:initialize()
    for i,v in self:iter() do
        if v.initialize then
            v:initialize()
        end
    end
    return self
end

function Node:release()
    for i,v in self:iter(true) do
        if v.release then
            v:release()
        end
    end
    return self
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

function Node:computeSize()
    self:layout()
end

function Node:draw()
    if self.visible == false then return end
    
    for i,node in self:iter() do
        if node.draw then
            pushMatrix()
            do
                if node.position then
                    translate(node.position.x, node.position.y)
                    if node.drawMode == CENTER then
                        translate(node.size.x/2, node.size.y/2, node.size.z/2)
                    end
                end

                if node.translation then
                    translate(node.translation.x, node.translation.y, node.translation.z)
                end

                if node.scaling then
                    scale(node.scaling.x, node.scaling.y, node.scaling.z)
                end

                if node.angle and node.angle ~= 0 then
                    rotate(node.angle)
                end

                if node.rotation then
                    if type(node.rotation) == 'number' then
                        if node.rotation ~= 0 then
                            rotate(node.rotation)
                        end
                    else
                        rotate(node.rotation.y, 1, 0, 0)
                        rotate(node.rotation.x, 0, 1, 0)
                    end
                end

                if node.drawMode == CENTER then
                    translate(-node.size.x/2, -node.size.y/2)
                end

                node:draw()

                if node.body and env.physics.debug then
                    node.body:draw(dt)
                end
            end
            popMatrix()
        end
    end

    strokeWidth(1)
    if self.hasFocus then
        stroke(red)
    else
        stroke(51)
    end

    noFill()

    rectMode(CORNER)
    rect(0, 0, self.size.x, self.size.y)
end

function Node:drawAbsolutePosition()
    if self.visible == false then return end
    if not self.absolutePosition then return end

    stroke(white)
    strokeWidth(10)

    for i,node in self:iter() do
        if node.absolutePosition then
            point(
                node.absolutePosition.x-self.absolutePosition.x,
                node.absolutePosition.y-self.absolutePosition.y)

            if node.drawAbsolutePosition then
                node:drawAbsolutePosition()
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
