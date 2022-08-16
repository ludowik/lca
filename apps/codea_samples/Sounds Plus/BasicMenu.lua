BasicMenu = class()

function BasicMenu:init()
    self.sounds = {"SOUND_BLIT", "SOUND_EXPLODE", "SOUND_HIT",
                   "SOUND_POWERUP", "SOUND_JUMP", "SOUND_SHOOT",
                   "SOUND_PICKUP", "SOUND_RANDOM"}
    self.buttons = {}

    for _,v in pairs(self.sounds) do
        table.insert( self.buttons, SoundButton(v) )
    end
end

function BasicMenu:onEnter()
    parameter.clear()
    output.clear()
    viewer.mode = FULLSCREEN
end

function BasicMenu:draw()
    self:drawButtons(self.buttons)
end

function BasicMenu:drawButtons(btns)
    pushStyle()

    fill(255, 255, 255, 255)
    font("ArialRoundedMTBold")
    textWrapWidth(WIDTH-20)
    textAlign(CENTER)
    textMode(CENTER)
    text("Tap a sound below to play a random variation of that sound",
         WIDTH/2, HEIGHT - layout.safeArea.top - 18)

    local top = HEIGHT - (HEIGHT*0.2)
    local left = WIDTH/2
    for _,b in pairs(btns) do
        b.pos = vec2(left,top)
        b:draw()

        top = top - b.size.y -10
    end

    popStyle()
end

function BasicMenu:touched(touch)
    for _,b in pairs(self.buttons) do
        b:touched(touch)
    end
end
