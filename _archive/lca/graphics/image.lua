class 'image'

function image.setup()
    image.images = table()
end

function image.getImage(imageRef)
    if not image.images[imageRef] then
        image.images[imageRef] = image(imageRef)
    end
    return image.images[imageRef]
end

function image:init(param, ...)
    self.needUpdate = false
    
    if type(param) == 'string' then
        local img
        local imageRef = param
        local i, len, imageLibrary, imageName = imageRef:find('(.*):(.*)')

        imageLibrary = imageLibrary or 'documents'
        imageName = imageName or param

        local imagePath = 'res/images/'..imageLibrary..'/'..imageName..'.png'
        if not isFile(imagePath) then            
            imagePath = 'res/images/'..imageLibrary..'/'..imageName..'.jpg'
        end
        if isFile(imagePath) then            
            img = love.graphics.newImage(imagePath)
            self.width, self.height = img:getWidth(), img:getHeight()
            self.canvas = love.graphics.newCanvas(self.width, self.height)
            setContext(self)
            love.graphics.draw(img)
            setContext()
        else
            self.width, self.height = 100, 100
            self.canvas = love.graphics.newCanvas(self.width, self.height)
        end
    else
        local w, h = param, ...
        h = h or w
        self.width, self.height = w, h
        self.canvas = love.graphics.newCanvas(w, h)
    end
end

function image:background(...)
    setContext(self)
    background(...)
    setContext()
end

function image:get(x, y)
    if x < 1 or y < 1 or x > self.width or y > self.height then return transparent end

    self.imageData = self.imageData or self.canvas:newImageData()
    return color(self.imageData:getPixel(x-1, y-1))
end

function image:set(x, y, r, ...)
    if x < 1 or y < 1 or x > self.width or y > self.height then return end

    local g,b,a
    if type(r) == 'number' then
        r,g,b,a = r,...
    else
        r,g,b,a = r.r, r.g, r.b, r.a
    end
    
    self.imageData = self.imageData or self.canvas:newImageData()
    self.imageData:setPixel(x-1, y-1, r, g, b, a)
    
    self.needUpdate = true
end

function image:copy(x, y, w, h)
    x = x or 0
    y = y or 0

    w = w or self.width
    h = h or self.height

    local img = image(w, h)

    local from = self
    local to = img

    for i=1,w do
        for j=1,h do
            to:set(i, j, from:get(x+i, y+j))
        end
    end

    img:update()

    return img
end

function image:update(needUpdate)
    if self.imageData and ( self.needUpdate or needUpdate) then
        local img = love.graphics.newImage(self.imageData)
        setContext(self)
        love.graphics.draw(img)
        setContext()
        self.needUpdate = false
    end
end

function setContext(img)
    if img then
        push('canvas', love.graphics.getCanvas())
        love.graphics.push()
        love.graphics.origin()
        love.graphics.setCanvas(img.canvas)
    else
        love.graphics.setCanvas(pop('canvas') or app.win.canvas)
        love.graphics.pop()
    end
end
