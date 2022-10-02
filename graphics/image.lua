class 'Image'

function Image.setup()
    Image.images = table()
end

function Image.release()
    Image.images = table()
end

function Image.findImage(name)
    if love.filesystem.getInfo(name) then return name end

    if name:find(':') then
        local searchName = 'res/images/'..name:replace(':', '/')
        if love.filesystem.getInfo(searchName) then return searchName end
        searchName = 'res/images/'..name:replace(':', '/')..'.png'
        if love.filesystem.getInfo(searchName) then return searchName end
        searchName = 'res/images/'..name:replace(':', '/')..'.jpeg'
        if love.filesystem.getInfo(searchName) then return searchName end
    end

    log('image not found : '..name)
    
    return name
end

function Image.getImage(res)
    if type(res) == 'string' then
        if not Image.images[res] then
            Image.images[res] = Image(Image.findImage(res))
        end
        return Image.images[res]
    end
    return res
end

function Image:init(name, ...)
    if type(name) == 'table' and name.__className == 'Image' then
        return name
    end

    if type(name) == 'string' then
        name = Image.findImage(name)
        local res, data = pcall(function ()
                return love.graphics.newImage(Image.findImage(name))
            end)
        if not res then return Image() end

        self.data = data
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
    self.imageData:encode('png', filename)
end

function Image:getWidth()
    return self.data:getWidth()
end

function Image:getHeight()
    return self.data:getHeight()
end

function Image:copy(x, y, w, h)
    x = x or 0
    y = y or 0

    w = w or self:getWidth()
    h = h or self:getHeight()

    local copy = Image(w, h)
    copy.imageData:paste(self.imageData, 0, 0, x, y+h, w, h)

    return copy
end

function Image:background(clr)
    clr = clr or colors.black
    local previousContext = setContext(self)
    love.graphics.clear(clr:unpack())
    setContext(previousContext)
end

function Image:update()
    if self.imageData then
        self.data:replacePixels(self.imageData)
    end
end

function Image:scale(scale)
    local w, h = self.width * scale, self.height * scale
    local img = Image(w, h)
    render2context(function () self:draw(0, 0, w, h) end, img)
    return img
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

function Image:get(x, y, clr)
    local r, g, b, a = self.imageData:getPixel(x, y)
    if clr then
        clr:set(r, g, b, a)
    end
    return r, g, b, a
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
