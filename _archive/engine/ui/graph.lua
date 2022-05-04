Graph = class(UI)

function Graph:init()
    UI.init()
    self.values = table()
end

function Graph:add(value)
    self.values:add(value)
end

function Graph:draw()
end
