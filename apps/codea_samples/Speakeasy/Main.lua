-- Speakeasy

-- A little demo of the speech API

-- When the demo runs it will show the keyboard and
--  allow you to type.
-- typing will start a timer, once finished it will
--  say what you've written using the speech API

-- See the Sounds chapter in the docs for more info
--  on the speech API

function setup()
    print("Type words to speak them")
    
    words = "Type some words for me to speak! "
    lastSpoken = ""
    resetSpeakDelay()
    
    progressView = Progress()
    
    parameter.number("SpeechRate", 0, 1, 0.1, function(val)
        speech.rate = val
    end)
    
    parameter.number("SpeechPitch", 0.5, 2, 1, function(val)
        speech.pitch = val
    end)

    parameter.action("Pause", function()
        if speech.paused then
            speech.continue()
        else
            speech.pause()
        end
    end)

    showKeyboard()

end

function resetSpeakDelay()
    speakDelay = 1.0
end

function speakWords()
    
    resetSpeakDelay()
    
    if words ~= "" then
        speech.say(words)
        
        lastSpoken = words
        
        words = ""
    end
end

function keyboard(key)
    
    resetSpeakDelay()
    
    if key == RETURN then
        speakWords()
    elseif key == BACKSPACE then
        words = string.sub(words, 1, -2)
    else
        words = words .. key
    end

end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)
    fill(255, 0, 148, 255)

    -- Do your drawing here
    if words then
        font("Vegur")
        fontSize(60)
        textWrapWidth(WIDTH - 20)
        text(words, WIDTH/2, HEIGHT*0.75)
    end
    
    if speakDelay <= 0 then
        speakWords()
    end
    
    speakDelay = speakDelay - DeltaTime 
    
    progressView.pos = vec2(WIDTH - 100, HEIGHT - 100)
    progressView.color = color(fill())
    
    if string.len(words) > 0 then
        progressView.progress = 1 - speakDelay
        progressView.color.a = progressView.progress * 255        
    else
        progressView.progress = 0
    end
    
    progressView:draw()
end

function touched(touch)
    
    if touch.tapCount == 1 and touch.state == ENDED then
        showKeyboard()
    end
    
end
