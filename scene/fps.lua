local __round, __map = math.round, math.map

class 'Fps' : extends(UI)

function Fps:init()
    UI.init(self)

    self.count = 0
    self.frame = 0

    self.deltaTime = 0

    self.fpsHisto = table()

    self.goodFps = green:alpha(64)
    self.badFps = red:alpha(64)
end

function Fps:update(dt)
    dt = dt or deltaTime

    if self.count == config.framerate then
        self.deltaTime = self.deltaTime / self.count
        self.count = 1
    end

    self.count = self.count + 1
    self.frame = self.frame + 1

    self.deltaTime = self.deltaTime + dt

    if self.count > 1 then
        self.fpsHisto:add(self:fps())

        if #self.fpsHisto > self.size.x then
            self.fpsHisto:dequeue()
        end
    end
end

function Fps:fps()
    return __round(1 / (self.deltaTime / self.count))
end

function Fps:computeSize()
    font(DEFAULT_FONT_NAME)
    fontSize(self.fontSize)

    self.size.x, self.size.y = textSize(' 60 ')
end

function Fps:draw()
    local x, y = 0, 0

    font(DEFAULT_FONT_NAME)
    fontSize(12)

    self:drawStats(x, y)
    self:drawCounter(x, y)
end

function Fps:drawStats(x, y)
    local n = #self.fpsHisto

    strokeSize(1)

    for i=1,n do
        local fps = self.fpsHisto[i]

        if fps < config.framerate * 0.8 then
            stroke(self.badFps)
        else
            stroke(self.goodFps)
        end
        line(x+i, y, x+i, y+__map(fps, 0, config.framerate, 0, self.size.y))
    end
end

function Fps:drawCounter(x, y)
    local fps = self.fpsHisto[#self.fpsHisto] or ''

    local w, h = textSize(fps)

    fill(white)
    textMode(CENTER)

    font(DEFAULT_FONT_NAME)
    fontSize(self.fontSize)

    text(fps,
        x + self.size.x / 2,
        y + self.size.y / 2)
end
