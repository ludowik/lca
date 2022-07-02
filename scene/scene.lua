class 'Scene' : extends(Node)

function Scene:init()
    Node.init(self)
end

function Scene:layout(x, y)
    local nodes = self:items()

    local w, h = 0, 0

    x, y = x or 0, y or 0
    for i,node in ipairs(nodes) do
        if node.position then
            node.position.x = x
            node.position.y = y

            if node.items then
                if node.layout then node:layout(x, y) end
            else
                if node.computeSize then node:computeSize() end
            end

            y = y + node.size.h

            w = max(w, node.size.w)
            h = y - self.position.y
        end
    end

    self.size:set(w, h)
end

function Scene:draw()
    if self.parent == nil then
--        background()
    end    

    self:layout(self.position.x, self.position.y)
--    print(self.__className)

--    if self.parent == nil then
--        self.modelMatrix = matrix():clone()
--    else
--        self.modelMatrix = modelMatrix():clone()
--    end
    Node.draw(self)
end

function Node:draw()
--    translate(self.position.x, self.position.y)

    local nodes = self:items()
    for i,node in ipairs(nodes) do
--        modelMatrix(self.modelMatrix)

        if node.position and node.items == nil then
            pushMatrix()
            translate(node.position.x, node.position.y)
        end
        node:draw()
        if node.position and node.items == nil then
            popMatrix()
        end

    end    
end

function Scene:touched(touch)
    local x, y = 0, 0
    local nodes = self:items()
    for i,node in ipairs(nodes) do
        if node:contains(touch) then
--            if touch.state == RELEASED then
--                if touch.tx == 0 and touch.ty == 0 then
--                    node:callback()
--                end
--            else
            node:touched(touch)
--            end
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
