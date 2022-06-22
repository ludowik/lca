class 'Scene' : extends(Node)

function Scene:init()
    Node.init(self)
end

function Scene:layout(x, y)
    local nodes = self:items()

    local w, h = 0, 0

    x, y = x or 0, y or 0
    for i,node in ipairs(nodes) do
        assert(node.position)

        node.position.x = x
        node.position.y = y

        if node.items then 
            node:layout(x, y)
        else
            node:computeSize()
        end

        y = y + node.size.h

        w = max(w, node.size.w)
        h = y - self.position.y
    end

    self.size:set(w, h)
end

function Scene:draw()
    if self.parent == nil then
--        background()
    end    

    self:layout(self.position.x, self.position.y)
    
    self.modelMatrix = modelMatrix():clone()
    Node.draw(self)
end

function Node:draw()
--    translate(self.position.x, self.position.y)

    local nodes = self:items()
    for i,node in ipairs(nodes) do
        modelMatrix(self.modelMatrix)
        
        if node.position then
            translate(node.position.x, node.position.y)
        end
        node:draw()
        
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

