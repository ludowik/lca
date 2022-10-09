class 'Scene' : extends(Node)

function Scene:init()
    Node.init(self)
end

function Scene:clear()
    Node.clear(self)
    self.focus = nil
    return self
end

function Scene:draw()
    if self.camera then
        self.camera:lookAt()
    end

    if not self.parent then
        if self.layoutFlow then
            self:layout(self.position.x, self.position.y)
            Layout.align(self)
        end
        if not self:getFocus() then
            self:computeNavigation(self, self)
            self:nextFocus()
        end
    end

    if not self.parent and self.position and not self.layoutFlow then
        pushMatrix()
        translate(self.position.x, self.position.y)
    end

    Node.draw(self)

    if not self.parent and self.position and not self.layoutFlow then
        popMatrix()
    end

    local focusItem = self:getFocus()
    if focusItem then
        local focusPosition = focusItem:getPosition()
        stroke(colors.red)
        noFill()
        rect(focusPosition.x, focusPosition.y, focusItem.size.x, focusItem.size.y)
    end    
end

function Scene:touched(touch)
    local x, y = 0, 0
    local nodes = self:items()
    for i,node in ipairs(nodes) do
        if node:contains(touch) then
            node:touched(touch)
            break
        end
    end
end

function Scene:wheelmoved(dx, dy)
    local x, y = love.mouse.getPosition()
    x = x - X
    y = y - Y

    local nodes = self:items()
    for i,node in ipairs(nodes) do
        if node:contains(vec2(x, y)) then
            node:wheelmoved(dx, dy)
            break
        end
    end
end
