image = class 'Image'

function Image.getPath(imageName, ext)
    local path = getImagePath()
    path = path..'/'..imageName:replace(':', '/')..'.'..(ext or 'png')
    return path -- getFullPath(path)
end

function Image:init(w, h)
    if type(w) == 'number' then
        self:create(w, h or w)

    elseif type(w) == 'string' then
        local path = self.getPath(w)
        if getInfo(path) == nil then
            path = self.getPath(w, 'jpg')
            if getInfo(path) == nil then
                warning("image doesn't exists", 3)
                return self:init(100, 100)
            end
        end

        self.surface = sdl.image.IMG_Load(path)

        if self.surface == ffi.NULL then
            warning("image doesn't exists", 3)
            self:create(100, 100)
            return
        end

        self.width = self.surface.w
        self.height = self.surface.h

        self:reversePixels()

        self:makeTexture()

    elseif typeof(w) == 'image' then
        self:create(w.width, w.height)
        self:loadSubPixels(w.surface.pixels, w.formatRGB, 0, 0, w.width, w.height)

    else
        self:create(100, 100)
    end

    self.wh = self.width * self.height
    self.pixels = ffi.cast('GLubyte*', self.surface.pixels)
end

function Image:copy()
    local copy = Image(self.width, self.height)
    copy:makeTexture(self.surface)
    return copy
end

function Image:getPixels()
    return self.pixels
end

function Image:setPixels(pixels)
    self.needUpdate = true
    self.pixels = pixels
end

function Image:create(w, h)
    local surface = {
        w = max(1, w),
        h = max(1, h),

        format = {
            BytesPerPixel = 4,
            Rmask = 0xff
        }
    }

    surface.size = surface.w * surface.h * 4

    surface.pixels = ffi.new('GLubyte[?]', surface.size, 0)

    self.width = w
    self.height = h

    self:makeTexture(surface)
end

function Image:makeTexture(surface)
    if surface then
        self.surface = surface
    end

    if self.texture_id == nil or gl.glIsTexture(self.texture_id) == gl.GL_FALSE then
        self.texture_id = gl.glGenTexture()
    end

    gl.glBindTexture(gl.GL_TEXTURE_2D, self.texture_id)

    self.internalFormat = gl.GL_RGBA
    self.formatRGB = gl.GL_RGBA

    if self.surface.format.BytesPerPixel == 1 then
        if config.glMajorVersion >= 4 then
            self.internalFormat = gl.GL_ALPHA
            self.formatRGB = gl.GL_ALPHA
        else
            self.internalFormat = gl.GL_ALPHA
            self.formatRGB = gl.GL_ALPHA
        end

    elseif self.surface.format.BytesPerPixel == 3 then
        self.internalFormat = gl.GL_RGB
        if self.surface.format.Rmask == 0xff then
            self.formatRGB = gl.GL_RGB
        else
            self.formatRGB = gl.GL_BGR
        end

    elseif self.surface.format.BytesPerPixel == 4 then
        self.internalFormat = gl.GL_RGBA
        if self.surface.format.Rmask == 0xff then
            self.formatRGB = gl.GL_RGBA
        else
            self.formatRGB = gl.GL_BGRA
        end
    end

    gl.glTexImage2D(gl.GL_TEXTURE_2D,
        0, -- level
        self.internalFormat,
        self.surface.w, self.surface.h,
        0, -- border
        self.formatRGB, gl.GL_UNSIGNED_BYTE,
        self.surface.pixels)

    gl.glPixelStorei(gl.GL_UNPACK_ALIGNMENT, 1)

    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_LINEAR)
    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_LINEAR)

    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_S, gl.GL_CLAMP_TO_EDGE)
    gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_T, gl.GL_CLAMP_TO_EDGE)

    gl.glBindTexture(gl.GL_TEXTURE_2D, 0)

    return self
end

-- TODO
function Image:loadSubPixels(pixels, formatRGB, x, y, w, h, texParam, texClamp)
    texParam = texParam or gl.GL_LINEAR
    texClamp = texClamp or gl.GL_CLAMP_TO_EDGE

    self:use()
    do
        self.formatRGB = formatRGB or gl.GL_RGBA

        gl.glTexSubImage2D(gl.GL_TEXTURE_2D,
            0, -- level
            x, y,
            w, h,
            self.formatRGB, gl.GL_UNSIGNED_BYTE,
            pixels)

        gl.glPixelStorei(gl.GL_UNPACK_ALIGNMENT, 1)

        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, texParam)
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, texParam)

        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_S, texClamp)
        gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_WRAP_T, texClamp)
    end
    self:unuse()

    return true
end

function Image:readPixels(formatAlpha, formatRGB)
    self.formatRGB = formatRGB or gl.GL_RGBA

    self:use()
    do
        gl.glGetTexImage(gl.GL_TEXTURE_2D,
            0,
            self.formatRGB, gl.GL_UNSIGNED_BYTE,
            self.surface.pixels)
    end
    self:unuse()
end

function Image:reversePixels(pixels, w, h, bytesPerPixel)
    debugger.off()

    if pixels == nil then
        pixels = self.surface.pixels

        w = self.surface.w
        h = self.surface.h

        bytesPerPixel = self.surface.format.BytesPerPixel
    end

    local p = ffi.cast('GLubyte*', pixels)

    local i, j
    for y = 1, h/2 do
        for x = 1, w do
            i = (w * (y-1) + (x-1)) * bytesPerPixel
            j = (w * (h-y) + (x-1)) * bytesPerPixel

            if bytesPerPixel == 1 then
                p[i+0], p[j+0] = p[j+0], p[i+0]

            elseif bytesPerPixel == 3 then
                p[i+0], p[j+0] = p[j+0], p[i+0]
                p[i+1], p[j+1] = p[j+1], p[i+1]
                p[i+2], p[j+2] = p[j+2], p[i+2]

            elseif bytesPerPixel == 4 then
                p[i+0], p[j+0] = p[j+0], p[i+0]
                p[i+1], p[j+1] = p[j+1], p[i+1]
                p[i+2], p[j+2] = p[j+2], p[i+2]
                p[i+3], p[j+3] = p[j+3], p[i+3]
            end
        end
    end

    debugger.on()
end

function Image:reverseSurface(surface, bytesPerPixel)
    if sdl.SDL_LockSurface(surface) == 0 then
        self:reversePixels(surface.pixels, surface.w, surface.h, bytesPerPixel)
        sdl.SDL_UnlockSurface(surface)
    end
end

function Image:use(index)
    if gl.glIsTexture(self.texture_id) == gl.GL_TRUE then
        gl.glBindTexture(gl.GL_TEXTURE_2D, self.texture_id)
        gl.glActiveTexture(index or gl.GL_TEXTURE0)
    else
        error('no valid texture')
    end
end

function Image:unuse()
    gl.glBindTexture(gl.GL_TEXTURE_2D, 0)
end

function Image:background(...)
    setContext(self)
    background(...)
    setContext()    
end

function Image:draw(x, y, w, h)
    sprite(self, x, y, w or self.width, h or self.height, CORNER)
end

function Image:fragment(f)
    local fragColor

    local fragIndex = 0

    for y=1,self.surface.h do
        for x=1,self.surface.w do

            fragColor = f(x-1, y-1)

            self.surface.pixels[fragIndex  ] = fragColor.r * 255
            self.surface.pixels[fragIndex+1] = fragColor.g * 255
            self.surface.pixels[fragIndex+2] = fragColor.b * 255
            self.surface.pixels[fragIndex+3] = fragColor.a * 255

            fragIndex = fragIndex + 4

        end
    end

    self:makeTexture()
end

local floor = math.floor

function Image:offset(x, y)
    x = round(x-1)
    y = round(y-1)

    local offset = self.width * y + x
    if (offset >= 0 and
        offset < self.wh)
    then
        return offset * self.surface.format.BytesPerPixel
    end
end

function Image:set(x, y, color_r, g, b, a)
    a = a or 1

    if type(color_r) == 'cdata' then
        color_r, g, b, a = color_r.r, color_r.g, color_r.b, color_r.a
    end

    local offset = self:offset(x, y)
    if offset then
        local pixels = self.pixels -- self:getPixels()

        if self.surface.format.BytesPerPixel == 4 then
            pixels[offset  ] = color_r * 255
            pixels[offset+1] = g * 255
            pixels[offset+2] = b * 255
            pixels[offset+3] = a * 255

        elseif self.surface.format.BytesPerPixel == 3 then
            pixels[offset  ] = color_r * 255
            pixels[offset+1] = g * 255
            pixels[offset+2] = b * 255

        elseif self.surface.format.BytesPerPixel == 1 then
            pixels[offset  ] = color_r * 255

        else
            assert()
        end

        self.needUpdate = true
    end
end

function Image:get(x, y, clr)
    clr = clr or Color()

    local offset = self:offset(x, y)
    if offset then
        local pixels = self.pixels -- self:getPixels()

        local scale = 1 / 255

        if self.surface.format.BytesPerPixel == 4 then
            clr.r = pixels[offset  ] * scale
            clr.g = pixels[offset+1] * scale
            clr.b = pixels[offset+2] * scale
            clr.a = pixels[offset+3] * scale

        elseif self.surface.format.BytesPerPixel == 3 then
            clr.r = pixels[offset  ] * scale
            clr.g = pixels[offset+1] * scale
            clr.b = pixels[offset+2] * scale
            clr.a = 1

        elseif self.surface.format.BytesPerPixel == 1 then
            clr.r = pixels[offset  ] * scale
            clr.g = clr.r
            clr.b = clr.r
            clr.a = 1

        else
            assert()
        end

        return clr
    end

    return clr:set()
end

function Image:update(needUpdate)
    if self.needUpdate or needUpdate then
        self.needUpdate = false
        self:makeTexture()
    end
end

function Image:copy(x, y, w, h)
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

    img:makeTexture()

    return img
end

function Image:createFramebuffer()
    -- The framebuffer, which regroups 0, 1, or more textures, and 0 or 1 depth buffer
    if self.framebufferName == nil then
        self.framebufferName = gl.glGenFramebuffer()
        gl.glBindFramebuffer(gl.GL_FRAMEBUFFER, self.framebufferName)
    end
    return self.framebufferName
end

function Image:createColorBuffer(w, h)
    -- The color buffer
    if self.colorRenderbuffer == nil then
        self.colorRenderbuffer = gl.glGenRenderbuffer()
        gl.glBindRenderbuffer(gl.GL_RENDERBUFFER, self.colorRenderbuffer)
        gl.glRenderbufferStorage(gl.GL_RENDERBUFFER, gl.GL_RGBA, w, h)
        gl.glBindRenderbuffer(gl.GL_RENDERBUFFER, engine.defaultRenderBuffer or 0)
        gl.glFramebufferRenderbuffer(gl.GL_FRAMEBUFFER, gl.GL_COLOR_ATTACHMENT0, gl.GL_RENDERBUFFER, self.colorRenderbuffer)
    end
    return self.colorRenderbuffer
end

function Image:createDepthBuffer(w, h)
    -- The depth buffer
    if self.depthRenderbuffer == nil then
        self.depthRenderbuffer = gl.glGenRenderbuffer()
        gl.glBindRenderbuffer(gl.GL_RENDERBUFFER, self.depthRenderbuffer)
        gl.glRenderbufferStorage(gl.GL_RENDERBUFFER, gl.GL_DEPTH_COMPONENT24, w, h)
        gl.glBindRenderbuffer(gl.GL_RENDERBUFFER, engine.defaultRenderBuffer or 0)
        gl.glFramebufferRenderbuffer(gl.GL_FRAMEBUFFER, gl.GL_DEPTH_ATTACHMENT, gl.GL_RENDERBUFFER, self.depthRenderbuffer)
    end
    return self.depthRenderbuffer
end

function Image:attachTexture2D(renderedTexture)
    -- Set "renderedTexture" as our colour attachement #0
    gl.glFramebufferTexture2D(gl.GL_FRAMEBUFFER, gl.GL_COLOR_ATTACHMENT0, gl.GL_TEXTURE_2D, renderedTexture, 0)
    --    gl.glFramebufferTexture(gl.GL_FRAMEBUFFER, gl.GL_COLOR_ATTACHMENT0, renderedTexture, 0)

    -- Set the list of draw buffers
    gl.glDrawBuffer(gl.GL_COLOR_ATTACHMENT0)
end

function Image:release()
    if gl.glIsTexture(self.texture_id) == gl.GL_TRUE then
        gl.glDeleteTexture(self.texture_id)
        self.texture_id = -1
        self.surface.pixels = nil
    end

    if self.framebufferName then
        gl.glDeleteFramebuffer(self.framebufferName)
        self.framebufferName = nil
    end

    if self.colorRenderbuffer then
        gl.glDeleteRenderbuffer(self.colorRenderbuffer)
        self.colorRenderbuffer = -1
    end

    if self.depthRenderbuffer then
        gl.glDeleteRenderbuffer(self.depthRenderbuffer)
        self.depthRenderbuffer = -1
    end
end

function Image:freeSurface(surface)
    sdl.SDL_FreeSurface(surface)
end

function Image:save(imageName, ext)
    if ios and love then return end

    local pixels = self:readPixels()

    local rmask = 0x000000ff
    local gmask = 0x0000ff00
    local bmask = 0x00ff0000
    local amask = 0xff000000

    local surface = sdl.SDL_CreateRGBSurfaceFrom(pixels, self.width, self.height, 32, 4*self.width, rmask, gmask, bmask, amask)
    if surface ~= NULL then
        self:reverseSurface(surface, 4)

        sdl.image.IMG_SavePNG(surface, getFullPath(image.getPath(imageName, ext)))
        self:freeSurface(surface)
    end
end
