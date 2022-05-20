class 'Image'

function Image:init(name, ...)
    if type(name) == 'string' then
        self.data = love.graphics.newImage(name)
    
    else
        local w, h = name, ...
        h = h or w
        self.imagedata = love.image.newImageData(w, h)
        self.data = love.graphics.newImage(self.imagedata)
            
    end
    
    self.width = self.data:getWidth()
    self.height = self.data:getHeight()
end

function Image:getWidth()
    return self.data:getWidth()
end

function Image:getHeight()
    return self.data:getHeight()
end

function Image:background(clr)
    -- TODO
end

function Image:draw(x, y, w, h)
    w = w or self:getWidth()
    h = h or self:getHeight()

    love.graphics.draw(self.data,
        x, y,
        0,
        w/self:getWidth(), h/self:getHeight())
end

function Image:set(x, y)
    -- TODO
end

function Image:get(x, y)
    -- TODO
end
