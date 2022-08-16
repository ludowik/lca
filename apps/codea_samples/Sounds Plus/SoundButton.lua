SoundButton = class(Button)

function SoundButton:init(displayName)
    Button.init(self, displayName)

    -- you can accept and set parameters here
    self.soundName = loadstring( "return "..displayName )()
    self.color = color(87, 129, 231, 255)

    self.action = function () sound(self.soundName) end
end

function SoundButton:draw()
    -- Codea does not automatically call this method
    pushStyle()
    fill(111, 159, 226, 255)

    font("ArialRoundedMTBold")
    fontSize(math.min(WIDTH,HEIGHT)/32)

    -- use longest sound name for size
    local w,h = textSize("SOUND_POWERUP")
    w = w + 20
    h = h + 30

    roundRect(self.pos.x - w/2,
              self.pos.y - h/2,
              w,h,w/12)

    self.size = vec2(w,h)

    textMode(CENTER)
    fill(54, 65, 96, 255)
    text(self.displayName,self.pos.x+2,self.pos.y-2)
    fill(255, 255, 255, 255)
    text(self.displayName,self.pos.x,self.pos.y)

    popStyle()
end
