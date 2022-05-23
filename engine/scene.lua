class 'Node'

function Node:init()
    self:clear()
end

function Node:clear()
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

function Node:layout()
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


class 'Scene' : extends(Node)

class 'UI'

function UI:update(dt)
end

function UI:draw()
end

class 'Expression' : extends(UI)
class 'Slider' : extends(UI)
class 'Button' : extends(UI)
class 'ListBox' : extends(UI)

class 'ToolBar' : extends(Node)
class 'MenuBar' : extends(Node)

class 'Object'

function Object:update(dt)
end

function Object:draw()
end

class 'MeshObject' : extends(Object)
