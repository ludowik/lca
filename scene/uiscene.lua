class 'UIScene' : extends(Scene)

function UIScene:init(...)
    Scene.init(self)
    Node.setLayoutFlowFromParam(self, ...)
end
