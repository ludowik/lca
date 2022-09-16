App('BBTan')

function BBTan:init()
    Application.init(self, 'BBTan')
    
    BBTan.tileSize = 20
    
    BBTan.position = vec2(100, 100)
    BBTan.size = vec2(BBTan.tileSize*10, 400)
    
    self.physics = Physics(0, 0)
    
    self:new()
end

function BBTan:new()
    self.scene = Scene()
    self.blocks = Scene()
    self.balls = Scene()
    
    self.scene:add(self.blocks)
    self.scene:add(self.balls)
    
    self.blocks:add(Block(self.physics, random(10), 1))
    self.blocks:add(Block(self.physics, random(10), 1))
    
    local ball = Ball(self.physics)
    self.balls:add(ball)
    ball.body:setLinearVelocity(-64, 256)
    
    local w, h = BBTan.size.w, BBTan.size.h
    self.physics:edge(0, 0, w, 0)
    self.physics:edge(w, 0, w, h)
    self.physics:edge(w, h, 0, h)
    self.physics:edge(0, h, 0, 0)
end

function BBTan:update(dt)
    self.physics:update(dt)
    self.scene:update(dt)
end

function BBTan:draw()
    background()
    
    translate(BBTan.position.x, BBTan.position.y)
    self.scene:draw()
    
    rectMode(CORNER)
    rect(0, 0, BBTan.size.w, BBTan.size.h)
    
    self.physics:draw()
end

function BBTan:mouse(x, y)
    self.text = table{x=x,y=y}
end

Entity = class('Entity', Rect)

Ball = class('Ball', Entity)

function Ball:init(physics)
    Entity.init(self)
    
    self.position:set(100, 50)
    self.size:set(BBTan.tileSize/2)
    
    physics:body(self, CIRCLE)
    self.body:setFriction(0)
    self.body:setRestitution(1)
end

function Ball:draw()
    stroke(colors.white)
    circle(self.position.x, self.position.y, self.size.w)
end

Block = class('Block', Entity)

function Block:init(physics, i, j, count)
    Entity.init(self)
    
    self.i = i
    self.j = j
    
    self.count = count or 1
    
    self.position:set(
        (i-0.5)*BBTan.tileSize,
        BBTan.size.h-(j+0.5)*BBTan.tileSize)
    
    self.size:set(20)
    
    physics:body(self, RECT)
    self.body:setType('static')
    self.body:setFriction(0)
    self.body:setRestitution(1)
end

function Block:draw()
    stroke(colors.white)
    local x, y = self.position.x, self.position.y
    rectMode(CENTER)
    rect(x, y, self.size.w, self.size.h)
    text(self.count, x, y)
end
    