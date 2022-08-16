class 'Speech'

function Speech:init()
    self.rate = 1
    self.pitch = 1

    self.paused = false
end

function Speech:continue()
    self.paused = true
end

function Speech:pause()
    self.paused = false
end

function Speech:say()
end

SpeechInstance = function ()
    local speech = Speech()

    local interface = {}
    
    for k,f in pairs(Speech) do
        if type(f) == 'function' then
            interface[k] = function (...)
                return f(speech, ...)
            end
        end
    end

    return interface
end
