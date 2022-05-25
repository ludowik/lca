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

function Scene:init()
    Node.init(self)
end

class 'UI' : extends(Rect)

function UI:init()
    Rect.init(self)
end

function UI:bind()    
end

function UI:update(dt)
end

function UI:draw()
end

class 'Expression' : extends(UI)
class 'Label' : extends(UI)
class 'Slider' : extends(UI)
class 'Button' : extends(UI)
class 'ButtonColor' : extends(UI)
class 'ButtonImage' : extends(UI)
class 'ButtonIconFont' : extends(UI)
class 'ListBox' : extends(UI)
class 'CheckBox' : extends(UI)
class 'UITimer' : extends(UI)
class 'UILine' : extends(UI)
class 'ColorPicker' : extends(UI)
class 'ToolBar' : extends(Node)

function ToolBar:init()
    Node.init(self)
end


class 'MenuBar' : extends(Node)

function MenuBar:init()
    Node.init(self)
end

class 'Object'

function Object:update(dt)
end

function Object:draw()
end

class 'Joystick' : extends(UI)


class 'UIScene' : extends(Scene)

function UIScene:init()
    Scene.init(self)
end

function UIScene:setGridSize()
end

class 'Tabs' : extends(UIScene)

function Tabs:init()
    UIScene.init(self)
end

function Tabs:addTab()
end

class 'Tab' : extends(UIScene)

function Tab:init()
    UIScene.init(self)
end

class 'Layout'

function Layout.setup()
    Layout.column = function () end
    Layout.row = function () end
    
    Layout.innerMarge = 2
end


class 'Dashboard' : extends(UI)

class 'Editor' : extends(Node)
