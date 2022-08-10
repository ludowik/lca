class 'Image'

function Image.setup()
    Image.images = table()
end

function Image.release()
    Image.images = table()
end

function Image.getImage(res)
    if type(res) == 'string' then
        if not Image.images[res] then
            if res:find(':') then
                res = 'res/images/'..res:replace(':', '/')..'.png'
            end
            Image.images[res] = Image(res)
        end
        return Image.images[res]
    end
    return res
end

function Image:init(name, ...)
    if type(name) == 'string' then
        self.data = love.graphics.newImage(name)
        self.imageData = love.image.newImageData(name)

    else
        local w, h = name, ...
        w = w or 100
        h = h or w
        self.imageData = love.image.newImageData(w, h)
        self.data = love.graphics.newImage(self.imageData)

    end

    if ffi then
        self.ptr = ffi.cast('uint8_t*', self.imageData:getFFIPointer())
        assert(self.ptr)

        self.ptrr = self.ptr + 0
        self.ptrg = self.ptr + 1
        self.ptrb = self.ptr + 2
        self.ptra = self.ptr + 3
    end
    
    self.depths = {}

    self.width = self.data:getWidth()
    self.height = self.data:getHeight()
end

function Image:reset()
    self:init(self.width, self.height)
end

function Image:save(filename)
    -- TODO
end

function Image:getWidth()
    return self.data:getWidth()
end

function Image:getHeight()
    return self.data:getHeight()
end

function Image:copy(x, y, w, h)
    w = w or self:getWidth()
    h = h or self:getHeight()

    local copy = Image(w, h)
    copy.imageData:paste(self.imageData, x, y, w, h)

    return copy
end

function Image:background(clr)
    -- TODO
end

function Image:update()
    if self.imageData then
        self.data:replacePixels(self.imageData)
    end
end

function Image:draw(x, y, w, h)
    w = w or self:getWidth()
    h = h or self:getHeight()

    self:update()

    love.graphics.draw(self.data,
        x, y,
        0,
        w/self:getWidth(), h/self:getHeight())
end

function Image:set(x, y, clr, ...)
    if type(clr) == 'number' then clr = Color(clr, ...) end
    self.imageData:setPixel(x, y, clr:unpack())
end

function Image:get(x, y)
    return self.imageData:getPixel(x, y)
end

function setContext(context)
    if context then
        push('canvas', love.graphics.getCanvas())
        push('context', context)
        context.canvas = context.canvas or love.graphics.newCanvas(context.width, context.height)
        love.graphics.setCanvas(context.canvas)
    else
        local canvas = pop('canvas')
        love.graphics.setCanvas(canvas)
        
        local context = pop('context')        
        context.imageData = context.canvas:newImageData()
        context.data = love.graphics.newImage(context.imageData)
        
    end
end
