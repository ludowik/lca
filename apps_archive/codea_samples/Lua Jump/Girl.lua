Girl = class()

function Girl:init()
    -- you can accept and set parameters here
    self.position = vec2(0,0)
    self.velocity = vec2(0,0)
end

function Girl:jump(power)
    sound(SOUND_JUMP)
    self.velocity = self.velocity + vec2(0,power)
end

function Girl:computeVelocity()
    gravity = vec2(Gravity.x, math.min(Gravity.y,-1)):normalize()
    gravity = gravity * 15
    friction = math.min(self.position.y, 1)
    return self.velocity + gravity * friction
end

function Girl:update()
    self.position = self.position + self:computeVelocity()

    -- Clamp y position
    -- (so you don't go through ground)
    self.position.y = math.max(self.position.y,0)

    -- Clamp x position
    self.position.x = math.max(self.position.x,-WIDTH/2)
    self.position.x = math.min(self.position.x,WIDTH/2)

    -- Dampen velocity
    self.velocity = self.velocity * 0.98
end

function Girl:isFalling()
    return self:computeVelocity().y < 0
end

function Girl:draw()
    self:update()

    pushMatrix()

    translate(self.position.x, self.position.y)

    sprite(asset.builtin.Planet_Cute.Character_Pink_Girl, 0, 0)

    popMatrix()
end
