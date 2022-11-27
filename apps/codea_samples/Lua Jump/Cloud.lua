Cloud = class()

function Cloud:init()
    -- you can accept and set parameters here
    self.shapes = {}
    self.position = vec2(0,0)
    
    -- Generate random cloud
    numCircles = math.random(4, 5)
    spacing = 30
    
    for i = 1,numCircles do
        x = i * spacing - ((numCircles/2)*spacing)
        y = (math.random() - 0.5) * 30
        rad = math.random(spacing, 2*spacing)     
        table.insert(self.shapes, {x=x, y=y, r=rad})
    end
    
    self.width = numCircles * spacing + spacing
end

function Cloud:isColliding(pos)
    startp = self.position.x - self.width/2
    endp = self.position.x + self.width/2
    
    if pos.x < endp and pos.x > startp and
       pos.y < (self.position.y + 30) and
       pos.y > (self.position.y + 10) then
        return true
    end
    
    return false
end

function Cloud:draw()
    pushStyle()
    pushMatrix()
    
    translate(self.position.x, self.position.y)
    
    noStroke()
    ellipseMode(RADIUS)
    fill(167, 190, 221, 255)
    
    for i,s in ipairs(self.shapes) do
        ellipse(s.x, s.y - 5, s.r)
    end
    
    fill(255, 255, 255, 255)
    
    for i,s in ipairs(self.shapes) do
        ellipse(s.x, s.y + 5, s.r)
    end
    
    popMatrix()
    popStyle()
end

