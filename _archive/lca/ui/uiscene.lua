class('UIScene', Scene, UI)

function UIScene:init(...)
    local label, layoutFlow, varargs = args(...):get(
        {'string', ''},
        {'function', Layout.column})

    --UI.init(self, label)
    Scene.init(self, label)

    self:setLayoutFlow(layoutFlow, unpack(varargs))
end

function UIScene:setLayoutFlow(layoutFlow, layoutParam)
    self.layoutFlow = layoutFlow
    self.layoutParam = layoutParam
    return self
end

function UIScene:setAlignment(alignment)
    self.alignment = alignment
    return self
end

function UIScene:setGridSize()
end

