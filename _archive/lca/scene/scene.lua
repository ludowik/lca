class 'Scene' : extends(Node)

function Scene:init(...)
    Node.init(self, ...)
end

function Scene:layout()
    local nodes = self:items()

    local x, y = 0, 0
    for i,node in ipairs(nodes) do
        if node.position then
            node.position.y = y
            y = y + node.size.h
        end
    end
end

function Scene:touched(touch)
    local x, y = 0, 0
    local nodes = self:items()
    for i,node in ipairs(nodes) do
        if node:contains(touch) then
            if touch.state == RELEASED then
                if touch.tx == 0 and touch.ty == 0 then
                    node:callback()
                end
            else
                node:touched(touch)
            end
            break
        end
    end
end

function Scene:draw()
    self:layout()
    
    if self.parent == nil then
--        background()
    end    
    
    translate(self.position.x, self.position.y)

    local nodes = self:items()
    for i,node in ipairs(nodes) do
        pushMatrix()
        if node.position then
            translate(node.position.x, node.position.y)
        end
        node:draw()
        popMatrix()
    end    
end




-- TODO : on garde quoi


function Scene:_layout()
    if self.parent == nil then
        Node.computeNavigation(self, self, self)
    end

    if self.layoutFlow then
        if self.parent == nil then
            self.position:set(0, 0, 0)
            self.absolutePosition:set(0, 0, 0)
        end

        Node.layout(self)

        if self.alignment then
            Layout.align(self)
        end

        if self.parent == nil then
            Layout.computeAbsolutePosition(self)
--            Layout.reverse(self)
        end
    end
end

function Scene:_draw()
    pushMatrix()
    do
        if self.parent == nil then
            local camera = self.camera
            if camera then
                perspective()

                camera:setViewMatrix()

                light(true)

                MeshAxes()

                blendMode(NORMAL)
                depthMode(true)
                cullingMode(true)
            end

            if self.position then
                translate(self.position.x, self.position.y)
            end

            if self.bgColor then
                background(self.bgColor)
            end
        end

        Node.draw(self)
--        Node.drawAbsolutePosition(self)
    end
    popMatrix()
end