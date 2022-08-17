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
