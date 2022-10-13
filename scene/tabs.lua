class 'Tabs' : extends(UINode)

function Tabs:init(label)
    UINode.init(self, label or 'tabs')

    self.buttons = UINode('buttons', Layout.row)
    self.tabs = UINode(Layout.topleft)

    self:add(self.buttons)
    self:add(self.tabs)

    self.layoutFlow = Layout.column
end

function Tabs:addTab(tab)
    local button = Button(tab.label)
    button.tab = tab
    button.callback = function (button)
        self.currentTab.visible = false
        self.currentTab = button.tab
        button.tab.visible = true
    end

    self.buttons:add(button)
    self.tabs:add(tab)

    if self.currentTab == nil then
        self.currentTab = tab
        tab.visible = true
    else
        tab.visible = false
    end
    return self
end

function Tabs:addTabs(...)
    tabs = {...}
    for i=1,#tabs do
        local tab = tabs[i]
        if classnameof(tab) == 'tab' then
            self:addTab(tab)
        end
    end
    return self
end

function Tabs:draw()
    self.buttons:draw()
    if self.currentTab then
        self.currentTab:draw()
    end
end

function Tabs:inRect(position)
    local over = self.buttons:inRect(position)
    if over then
        return over
    end

    return self.currentTab:inRect(position)
end

class 'Tab' : extends(UINode)

function Tab:init(label)
    UINode.init(self)
    self.label = label or id(Tab)
end

function Tab:draw()
    local position = self.absolutePosition or self.position
    UINode.draw(self)
    
    stroke(colors.blue)
    noFill()
    rect(position.x, position.y, self.size.x, self.size.y)
end
