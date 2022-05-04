SPEED = 100

Ship = class(Cell)

function Ship:init()
    Cell.init(self, "ship")
    self.position = vec2(W/2, H/2)
    self.weapons = table()
end

function Ship:update(dt)
    Cell.update(self, dt)
    
    local n = #self.weapons
    for i,weapon in ipairs(self.weapons) do
        weapon.target = self.position:clone() + vec2(0, -10):rotate((i-1)*50)
    end
end

Ufo = class(Cell)

function Ufo:init()
    Cell.init(self, "ufo")
    
    self.position = vec2(W/2, H)
    self.size = 10
    self.health = 100
    
    self.clr = color(216, 67, 59)
    
    self.linearVelocity = vec2(0, -200)
end

function Ufo:draw()
    Cell.draw(self)
end

function Ufo:hitBy(bullet)
    self.health = self.health - bullet.power
    
    bullet.state = "dead"
    
    if self.health <= 0 then
        self.state = "dead"
        
        for i=1,10 do
            scene:add(Energy(self))
            end
        end
    end


Energy = class(Cell)

function Energy:init(o)
    Cell.init(self, "energy")
    
    self.position = o.position:clone()
    self.linearVelocity = vector.random() * SPEED * 3
    
    self.delay = 1
    self.size = self.delay
end

function Energy:update(dt)
    Cell.update(self, dt)
    self.size = self.delay
    self.clr.a = self.size * 10
end


Wave = class(Cell)

function Wave:init()
    Cell.init(self, "wave")
    
    self.state = "active"
    
    self.delay = 5
    self.deltaTime = 0
end

function Wave:update(dt)
    Cell.update(self, dt)
    if self.deltaTime > 1 then
        self.deltaTime = 0
        ufos:add(Ufo())
    end 
end
