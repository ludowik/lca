class 'UIScene' : extends(Scene)

function UIScene:init(...)
    local label, layoutFlow, layoutParam

    local args = {...}
    if #args == 1 then
        if type(args[1]) == 'string' then
            label = ...
        else
            layoutFlow = ...
        end

    elseif #args == 2 then
        if type(args[1]) == 'string' then
            label, layoutFlow = ...
        else
            layoutFlow, layoutParam = ...
        end

    elseif #args == 3 then
        label, layoutFlow, layoutParam = ...
    end

    assert(label == nil or type(label) == 'string')
    assert(layoutFlow == nil or type(layoutFlow) == 'function')
    assert(layoutParam == nil or type(layoutParam) == 'number')

    Scene.init(self, label)
    self:setLayoutFlow(layoutFlow or Layout.column, layoutParam)
end

function UIScene:computeSize()
end

function UIScene:setGridSize(n, m)
    self.gridSize = vec2(n, m)
end
