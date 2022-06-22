Weapon = class(Cell)

cadence = 60

function Weapon:init(ship)
    Cell.init(self, "weapon")
    self.ship = ship
    self.deltaTime = 0
end

function Weapon:update(dt)
    Cell.update(self, dt)
    if self.ship then
        if self.deltaTime > (60/cadence) then
            bullets:add(Bullet(self))
            self.deltaTime = 0
        end
    end
end

function Weapon:hitBy(ship)
    self.ship = ship
    ship.weapons:add(self)
end

Bullet = class(Cell)
function Bullet:init(weapon)
    Cell.init(self, "bullet")
    self.weapon = weapon
    self.position = weapon.position:clone()
    self.linearVelocity = vec2(0, H)
    self.power = 50
end
