Scene = class(Entity)

function Scene:init()
    Entity.init(self)
    self.items = table()
end

function Scene:add(item)
    self.items:add(item)
end

function Scene:update(dt)
    for _,item in ipairs(self.items) do
        item:update(dt)
    end
end

function Scene:draw()
    for _,item in ipairs(self.items) do
        item:draw()
    end
end
