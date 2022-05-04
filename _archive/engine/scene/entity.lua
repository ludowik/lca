Entity = class(Rect)

function Entity:init()
    Rect.init(self)
end

function Entity:update(dt)
    if self.body then
        self.position:set(
            self.body:getX(),
            self.body:getY())
    end
end
