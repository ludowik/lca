class 'ToolBar' : extends(Node)

function ToolBar:init()
    Node.init(self)
    self:setLayoutFlow(Layout.row)
end

class 'MenuBar' : extends(Node)

function MenuBar:init()
    Node.init(self)
    self:setLayoutFlow(Layout.column)
end
