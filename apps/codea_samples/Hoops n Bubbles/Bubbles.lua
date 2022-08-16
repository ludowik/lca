Bubbles = class()

function Bubbles:init(x, y)
    self.x = x
    self.y = y
    self.bubbles = {}
    self.maxbubbles = 100
    self.bubblecount = 0
end

function Bubbles:emit()
    if self.bubblecount < self.maxbubbles then
        local dir = vec2(0,1):rotate(math.random() - 0.5) * math.random(1,6)
        local size = math.random(10, 50)
        local life = math.random(30, 60)
        local bubble = {pos = vec2(0,0), dir = dir, size = size, life = life}
        
        table.insert(self.bubbles, bubble)
        
        self.bubblecount = self.bubblecount + 1
    end
end

function Bubbles:update()
    for k,v in pairs(self.bubbles) do
        v.pos = v.pos + v.dir
        v.life = v.life - 1
        
        if v.life == 0 then
            self.bubbles[k] = nil
            self.bubblecount = self.bubblecount - 1
        end
    end
end

function Bubbles:draw()
    pushMatrix()
    pushStyle()
    translate(self.x, self.y)
    ellipseMode(CENTER)
    stroke(255)
    strokeWidth(4)
    fill(153, 197, 210, 100)
    for k,v in pairs(self.bubbles) do
        ellipse(v.pos.x, v.pos.y, v.size)
    end
    popStyle()
    popMatrix()
end