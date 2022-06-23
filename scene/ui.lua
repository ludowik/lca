class 'UIScene' : extends(Scene)

function UIScene:init()
    Scene.init(self)
end

function UIScene:setGridSize()
end

class 'UI' : extends(Rect, Bind)

function UI:init(label, callback)
    Rect.init(self)

    self.label = label or ''
    self.callback = callback

    self.styles = table({
            fontSize = 16,
        })
end

function UI.properties.set:value(value)
    self:setValue(value)
end

function UI.properties.get:value()
    return self:getValue()
end

function UI:setstyles(...)
    self.styles:attribs(...)
    return self
end

function UI:computeSize()
    fontSize(self.styles.fontSize or 16)
    self.size:set(textSize(self:getLabel()))
    
    self.size.x = max(self.size.x, 16)
    self.size.y = max(self.size.y, 16)
end

function UI:getLabel()
    return tostring(self.label or '')
end

function UI:update(dt)
end

function UI:draw()
    self:computeSize()

    if self.styles.bgColor then
        fill(self.styles.bgColor)
        rect(0, 0, self.size.w, self.size.h)
    end

    textColor(self.styles.textColor or colors.white)
    fontSize(self.styles.fontSize or 16)
    text(self:getLabel(), 0, 0)
end

function UI:touched(touch)
    if self.callback and touch.state == RELEASED then
        self.callback(self)
    end
end

class 'Label' : extends(UI)

class 'ListBox' : extends(UI)

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
