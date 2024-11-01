class 'UIScene' : extends(Scene)

function UIScene:init(...)
    Scene.init(self)
    Node.setLayoutFlowFromParam(self, ...)
    
    self.layoutFlow = self.layoutFlow or Layout.column
end

function UIScene:draw(...)
    self:drawUIScene(...)
end

class 'UINode' : extends(Node)

function UINode:init(...)
    Node.init(self, ...)
    
    self.layoutFlow = self.layoutFlow or Layout.column
end
