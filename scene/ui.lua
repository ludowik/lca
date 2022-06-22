class 'UIScene' : extends(Scene)

function UIScene:init()
    Scene.init(self)
end

function UIScene:setGridSize()
end

class 'UI' : extends(Rect)

function UI:init(label, callback)
    Rect.init(self)

    self.label = label or ''
    self.callback = callback
    
    self.textColor = colors.white
    self.fontSize = 16
end

function UI:bind()    
end

function UI:computeSize()
    fontSize(self.fontSize or 16)
    self.size:set(textSize(self:getLabel()))
end

function UI:getLabel()
    return tostring(self.label or '')
end

function UI:update(dt)
end

function UI:draw()
    self:computeSize()
    
    textColor(self.textColor or colors.white)    
    fontSize(self.fontSize or 16)
    
    text(self:getLabel(), 0, 0)
end

function UI:touched(touch)
    if self.callback and touch.state == RELEASED then
        self.callback(self)
    end
end

class 'Label' : extends(UI)
class 'Button' : extends(UI)
class 'ButtonColor' : extends(UI)
class 'ButtonImage' : extends(UI)
class 'ButtonIconFont' : extends(UI)
class 'ListBox' : extends(UI)

class 'CheckBox' : extends(UI)

function CheckBox:init(label, value, callback)
    UI.init(self, label, callback)
    self.value = value
end

function CheckBox:touched(touch)
    if self.callback and touch.state == RELEASED then
        self.value = not self.value
        self.callback(self, self.value)
    end
end

function CheckBox:draw()
    if self.value then
        self.textColor = colors.green
    else
        self.textColor = colors.red
    end
    
    UI.draw(self)
end

class 'UITimer' : extends(UI)
class 'UILine' : extends(UI)

class 'ColorPicker' : extends(UI)

function ColorPicker:init(label, clr, callback)
    UI.init(self, label, callback)
    self.clr = clr
end

class 'ToolBar' : extends(UIScene)

function ToolBar:init()
    UIScene.init(self)
end


class 'MenuBar' : extends(UIScene)
function MenuBar:init()
    UIScene.init(self)
end

class 'Object'
function Object:update(dt)
end

function Object:draw()
end

class 'Joystick' : extends(UI)


class 'Layout'
function Layout.setup()
    Layout.column = function () end
    Layout.row = function () end

    Layout.innerMarge = 2
end


class 'Dashboard' : extends(UI)

class 'Editor' : extends(Node)
