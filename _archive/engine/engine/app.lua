App = class(Rect)

function App:init(name)
    Rect.init(self)
    
    local w, h = love.graphics.getWidth(), love.graphics.getHeight()
    self.size:set(w, h)
    
    self.canvas = gx.canvas(self.size.w, self.size.h)
    
    self.text = name
end

function App:update(dt)
end

function App:draw()
end

function App:mouse(x, y)
end
