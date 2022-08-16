Pipe = class()

function Pipe:init(x,height,flip)
    -- you can accept and set parameters here

    self.x = x
    self.y = height / 2

    if flip then
        self.y = HEIGHT - self.y
    end

    self.width = pipeWidth
    self.height = height
    self.flip = flip

    local left = -self.width/2
    local right = self.width/2
    local top = self.height/2
    local bottom = -self.height/2

    self.body = physics.body(POLYGON, vec2(left,top),
    vec2(left,bottom), vec2(right, bottom), vec2(right,top))
    self.body.position = vec2(self.x, self.y)
    self.body.type = STATIC
    self.body.restitution = 1
end

function Pipe:draw()
    -- Codea does not automatically call this method
    pushMatrix()
    pushStyle()

    translate(self.body.x, self.body.y)
    if self.flip then scale(1,-1) end

    sprite(asset.builtin.Platformer_Art.Spikes, 0, self.height/2 + 15)

    local count = math.ceil(self.height/self.width)
    local offset = self.height - count * self.width
    for i = 1,count do
        local name = asset.builtin.Platformer_Art.Block_Brick
        if i == count then
            name = asset.builtin.Platformer_Art.Block_Grass
        end
        sprite(name, 0, -self.height/2 + i * self.width - self.width/2 + offset, self.width)
    end

    popStyle()
    popMatrix()
end
