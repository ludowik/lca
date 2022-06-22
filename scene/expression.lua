class 'Expression' : extends(UI)

function Expression:init(label, expression)
    UI.init(self, label)
    self.expression = expression or label
end

function Expression:getLabel()
    return self.label..' = '..tostring(evalExpression(self.expression) or '?')
end
