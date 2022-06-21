class 'Scene' : extends(Node)

function Scene:init()
    Node.init(self)
end

function Scene:layout(x, y)
    local nodes = self:items()

    x, y = x or 0, y or 0
    for i,node in ipairs(nodes) do
        if node.position then
            node.position.x = x
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

--    translate(self.position.x, self.position.y)

    local nodes = self:items()
    for i,node in ipairs(nodes) do
        pushMatrix()
        if node.position and node.items == nil then
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
        if node:contains(touch) then
--            if touch.state == RELEASED then
--                if touch.tx == 0 and touch.ty == 0 then
--                    node:callback()
--                end
--            else
            node:touched(touch)
--            end
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
    if self.callback and touch.state == RELEASED then
        self.callback(self)
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
