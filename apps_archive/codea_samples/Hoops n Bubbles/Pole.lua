Pole = class()

function Pole:init(x,y,helper)
    -- you can accept and set parameters here
    self.w = 15
    self.h = 50
    self.x = x
    self.y = y
    self.col = color(241, 241, 241, 255)
    self.top = makeBox(x,y, self.w, self.h)
    self.top.type = STATIC
    self.top.categories = {POLE}
    self.top.mask = {HOOP_EDGE}
    helper:addBody(self.top)
    
    self.base = makeBox(x,y-self.h/2-5, 30, self.w)
    self.base.type = STATIC
    self.base.categories = {GROUND}
    self.base.mask = {HOOP_EDGE, HOOP_MIDDLE}
    helper:addBody(self.base)
end

function Pole:draw()
    -- Codea does not automatically call this method
    pushMatrix()
    translate(self.x, self.y)
    pushStyle()
    
    stroke(self.col)
    strokeWidth(self.w)
    line(0, -self.h/2, 0, self.h/2 - self.w/2)
    lineCapMode(SQUARE)
    line(-self.w, -self.h/2-5, self.w, -self.h/2-5)
    
    popStyle()
    popMatrix()
end

function Pole:touched(touch)
    -- Codea does not automatically call this method
end
