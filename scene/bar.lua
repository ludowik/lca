class 'ToolBar' : extends(UIScene)

function ToolBar:init()
    UIScene.init(self, Layout.row)
end

class 'MenuBar' : extends(UIScene)

function MenuBar:init()
    UIScene.init(self, Layout.column)
end
