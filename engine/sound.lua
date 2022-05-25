class 'Sound'

function Sound.setup()
    AMPLITUDE_MAX = 100
end

function Sound:getSampleRate()
    return 10
end

function Sound:getSampleCount()
    return 10
end

function Sound:getSample(n)
    return 10
end

function Sound:loadBuffer(amplitude, hz, sampleRate)
end

function Sound:play()
end

function Sound:stop()
end

function sound()
    return Sound()
end

function soundBufferSize()
    return 0, 0
end
