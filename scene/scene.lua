class 'Scene' : extends(Node)

function Scene:init()
    Node.init(self)
    self.getOrigin = getOrigin
end

function Scene:clear()
    Node.clear(self)
    self.focus = nil
    return self
end

function Scene:draw()
    if not self.parent then
        if self.layoutFlow then
            self.draw = self.drawUIScene
        else
            self.draw = self.drawScene
        end
--        self:drawScene()
    else
        assert(false, 'Scene => '..self.__className)
    end
end

function Scene:drawScene(x, y)
    if self.camera then
        self.camera:lookAt()
    end

    if self.position then
        pushMatrix()
        translate(self.position.x, self.position.y)
    end

    Node.draw(self)

    if self.position then
        popMatrix()
    end
end

function Scene:drawUIScene(x, y)
    if x then
        self.position:set(x, y)
    else
        self.position:set()
    end

    self:layout()
    Layout.align(self)
    Layout.computeAbsolutePosition(self)
    if self:getOrigin() == BOTTOM_LEFT then
        Layout.reverse(self)
    end

    if not self:getFocus() then
        self:computeNavigation(self, self)
        self:nextFocus()
    end

    Node.draw(self)

    local focusItem = self:getFocus()
    if focusItem then
        local focusPosition = focusItem:getPosition()
        stroke(colors.red)
        noFill()
        rect(focusPosition.x, focusPosition.y, focusItem.size.x, focusItem.size.y)
    end    
end
