AdvancedMenu = class()

function AdvancedMenu:init()
    -- you can accept and set parameters here
    self.button = Button("Play Custom Sound")
    self.button.color = color(236, 62, 62, 255)
    self.button.action = function () playSound() end
end

function AdvancedMenu:onEnter()
    parameter.clear()
    output.clear()

    viewer.mode = OVERLAY

    print("This example allows you to play with the settings for sounds, and also documents them")

    parameter.action("Play Custom Sound", playSound)
    parameter.integer("waveform",0,3,0)
    parameter.number("attackTime",0,3,0.5)
    parameter.number("sustainTime",0,3,1)
    parameter.number("sustainPunch",0,3,0.0)
    parameter.number("decayTime",0,3,0.4)
    parameter.number("startFrequency",0,2,0.9)
    parameter.number("minFrequency",0,1,0)
    parameter.number("slide",0.9,1,0.96)
    parameter.number("deltaSlide",0,1,0.6)
    parameter.number("vibratoDepth",0,1,0.5)
    parameter.number("vibratoSpeed",0,1,0.5)
    parameter.number("changeAmount",0,1,0.6)
    parameter.number("changeSpeed",0,1,0.6)
    parameter.number("squareDuty",0,1,0.5)
    parameter.number("dutySweep",0,1,0.5)
    parameter.number("repeatSpeed",0,1,0.5)
    parameter.number("phaserSweep",0,1,0.5)
    parameter.number("lowpassFilterCutoff",0,1,0.5)
    parameter.number("lowpassFilterCutoffSweep",0,1,0.5)
    parameter.number("lowpassFilterResonance",0,1,0.5)
    parameter.number("highpassFilterCutoff",0,1,0.5)
    parameter.number("highpassFilterCutoffSweep",0,1,0.5)
    parameter.number("volume",0,1,1.0)
end

time = 0

function playSound()
    print("Playing custom sound")
    sound({ Waveform = waveform,
            AttackTime = math.pow(attackTime - 0.5, 3),
            SustainTime = math.pow(sustainTime - 0.5, 2),
            SustainPunch = math.pow(sustainPunch, 2),
            DecayTime = decayTime - 0.5,
            StartFrequency = math.pow(startFrequency,2),
            MinimumFrequency = minFrequency,
            Slide = math.pow(slide,5) - 0.5,
            DeltaSlide = deltaSlide - 0.5,
            VibratoDepth = math.pow(vibratoDepth - 0.5, 3),
            VibratoSpeed = vibratoSpeed - 0.5,
            ChangeAmount = changeAmount - 0.5,
            SquareDuty = squareDuty - 0.5,
            DutySweep = dutySweep - 0.5,
            RepeatSpeed = repeatSpeed - 0.5,
            PhaserSweep = phaserSweep - 0.5,
            LowPassFilterCutoff = 1- math.pow(lowpassFilterCutoff,3),
            LowPassFilterCutoffSweep = math.pow(lowpassFilterCutoffSweep - 0.5,3),
            LowPassFilterResonance = lowpassFilterResonance - 0.5,
            HighPassFilterCutoff = math.pow(highpassFilterCutoff,3),
            HighPassFilterCutoffSweep = math.pow(highpassFilterCutoffSweep - 0.5,3),
            Volume = volume })
end


function AdvancedMenu:draw()
    pushStyle()

    fill(255, 255, 255, 255)
    font("ArialRoundedMTBold")
    textWrapWidth(400)
    textAlign(CENTER)

    text("Use the sliders on the left to adjust the sound "..
         "then tap the play button to play it",
         WIDTH/2,HEIGHT - layout.safeArea.top - 18)

    self.button.pos = vec2(WIDTH/2,HEIGHT/2 + 100)
    self.button:draw()

    popStyle()
end

function AdvancedMenu:touched(touch)
    self.button:touched(touch)
end
