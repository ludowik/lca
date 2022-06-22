Cell = class(Object)

function Cell:init(className, size)
    Object.init(self)
    self.__className = className
    
    self.state = "active"
    
    self.position = vector.randomInScreen()    
    self.size = size or 5
    
    self.offset = vec2()
    
    self.clr = color(219, 183, 181)
end

function Cell:draw()
    fill(self.clr)
    rectMode(CENTER)
    rect(self.position.x, self.position.y, self.size)
    
    fontSize(12)
    textMode(CENTER)
    text(self.__className, self.position.x, self.position.y)
end

function Cell.collide(o1, o2)
    local v = o1.position - o2.position
    if v:len() < o1.size + o2.size then
        o2:hitBy(o1)
    end
end

function Cell.collisions(l1, l2)
    for i,o1 in ipairs(l1) do
        for j,o2 in ipairs(l2) do
            Cell.collide(o1, o2)
        end
    end
end
