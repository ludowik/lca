Menu = class(table)

function Menu:add(command)
    table.add(self, command)    
    self:layout()
end

function Menu:layout()
    for i,command in ipairs(self) do
        command.target = vec2(
            W - safeArea.right - command.size.x / 2,
            H / 2 + (command.size.y + 20) * (0.5 + #self / 2 - i))
    end  
end

Command = class(Object)

function Command:init(label, f)
    Object.init(self)

    self.fontSize = 20

    fontSize(self.fontSize)

    self.size = vec2(textSize(label)) * 2
    self.position = vec2(
        W - safeArea.right,
        H / 2)

    self.f = f
end

function Command:getSize()
    return self.size
end

function Command:getLabel()
    return self.label
end

function Command:contains(p)
    local dx = math.abs(p.x-self.position.x)
    local dy = math.abs(p.y-self.position.y)
    
    local size = self:getSize()
    
    if dx < size.x/2 and dy < size.y/2 then
        return true
    end
end

function Command:draw()
    local size = self:getSize()
    
    fill(63, 133, 212)
    rectMode(CENTER)
    rect(self.position.x, self.position.y, size.x, size.y)

    fill(226, 220, 219)
    fontSize(self.fontSize)
    textMode(CENTER)
    text(self:getLabel(), self.position.x, self.position.y)
end

function Command:touched(touch)
    if touch.state == BEGAN then
        if self.f then
            self.f()
        end
    end
end


Show = class(Command)

function Show:init(expression)
    Command.init(self, expression)
    self.expression = expression
end

function Show:getLabel()
    return evalExpression(self.expression)
end


