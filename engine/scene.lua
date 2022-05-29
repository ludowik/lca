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

function Scene:layout(x, y)
    local nodes = self:items()

    x, y = x or 0, y or 0
    for i,node in ipairs(nodes) do
        if node.position then
            node.position.y = y
            y = y + node.size.h
        end
    end
end

function Scene:draw()
    self:layout(self.position.x, self.position.y)

    if self.parent == nil then
--        background()
    end    

    translate(self.position.x, self.position.y)

    local nodes = self:items()
    for i,node in ipairs(nodes) do
        pushMatrix()
        if node.position then
            translate(node.position.x, node.position.y)
        end
        node:draw()
        popMatrix()
    end    
end

function Scene:touched(touch)
    local x, y = 0, 0
    local nodes = self:items()
    for i,node in ipairs(nodes) do
        print(Rect.__tostring(node))
        if node:contains(touch) then
            if touch.state == RELEASED then
                if touch.tx == 0 and touch.ty == 0 then
                    node:callback()
                end
            else
                node:touched(touch)
            end
            break
        end
    end
end

class 'UI' : extends(Rect)

function UI:init(label, callback)
    Rect.init(self)

    self.label = label or ''
    self.callback = callback
end

function UI:bind()    
end

function UI:computeSize()
    self.size:set(textSize(self:getLabel()))
end

function UI:getLabel()
    return tostring(self.label or '')
end

function UI:update(dt)
end

function UI:draw()
    self:computeSize()
    text(self:getLabel(), 0, 0)
end

function UI:touched(touch)
    if self.callback then
        self.callback()
    end
end

class 'Expression' : extends(UI)
function Expression:init(label, expression)
    UI.init(self, label)
    self.expression = expression or label
end

function Expression:getLabel()
    return self.label..' = '..tostring(evalExpression(self.expression) or '?')
end

class 'Label' : extends(UI)
class 'Slider' : extends(UI)
function Slider:init(variable, min, max, default, callback)
    UI.init(self, variable, callback)
    
    self.value = min
    self.min = min
    self.max = max
    self.default = default
end

function Slider:touched(touch)
    self.value = self.value + 1
    
    if self.callback then
        self.callback(self.value)
    end
end

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
