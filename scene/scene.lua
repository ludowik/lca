class 'Scene' : extends(Node)

function Scene:init()
    Node.init(self)
end

function Scene:draw()
    if self.camera then
        self.camera:lookAt()
    end

    self:layout(self.position.x, self.position.y)


    Node.draw(self)
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
