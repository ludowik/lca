Flapper = class()

function Flapper:init(x,y,speed)
    -- you can accept and set parameters here
    self.body = physics.body(CIRCLE, 25)
    self.body.interpolate = true
    self.body.x = x
    self.body.y = y
    self.speed = speed
    self.frames = {asset.builtin.Platformer_Art.Battor_Flap_1, asset.builtin.Platformer_Art.Battor_Flap_2, asset.builtin.Platformer_Art.Battor_Dead}
    self.body.tag = self
end

function Flapper:reset()
    self.dead = false
    self.body.fixedRotation = true
    self.body.angularVelocity = 0
    self.body.angle = 0
    self.animFrame = 1
    self.timer = 0
    self.body.linearVelocity = vec2(self.speed, 0)
    if self.joint then
        self.joint:destroy()
        self.joint = nil
    end
    self.shake = false
    self.offset = vec2(0,0)
end

function Flapper:kill(contact)
    if self.dead then
        return
    end
    if contact and math.abs(contact.normal.y) > 0.5 then
        self.joint = physics.joint(WELD, contact.bodyA, contact.bodyB, contact.position )
        self.joint.frequency = 5
        self.joint.dampingRatio = 0.1
    end
    self.body.fixedRotation = false
    self.body.angularVelocity = 90
    self.body.linearVelocity = vec2(-150,100)
    self.dead = true
    self.timer = 0
    self.animFrame = 3
    sound(SOUND_HIT)
    self.shake = true
end

function Flapper:draw()

    pushMatrix()
    translate(self.body.x,self.body.y)
    if self.shake then
        translate(math.random(-2,2), math.random(-2,2))
    end
    rotate(self.body.angle + self.body.linearVelocity.y * 0.05)
    scale(-1,1)
    if self.dead then
        scale(1,-1)
    end
    sprite(self.frames[self.animFrame], 0, 0, 125)
    popMatrix()

    if self.timer > 0 then
        self.timer = self.timer - DeltaTime
        if self.timer <= 0 then
            self.animFrame = 1
        end
    end

end

function Flapper:flap()

    if self.dead then
        return
    end

    sound(DATA, "ZgNAdgA0S09+QikzWzlhPqLUWD6psQc+GQABel5cVVNZQTUz")

    -- Codea does not automatically call this method
    local vel = self.body.linearVelocity
    vel.y = math.max(0, vel.y) + flapperForce
    self.body.linearVelocity = vel
    self.animFrame = 2
    self.timer = 0.25
end
