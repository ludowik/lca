local code, defs = Library.precompile(io.read('libc/sdl/sdl.c'))
ffi.cdef(code)

local _, loaded = pcall(loadstring('return ffi.SDL_Init'))

class 'Sdl' : extends(Component) : meta(not loaded and (ffi.load('SDL2') or Library.load('SDL2')) or ffi)

function Sdl:init()
    self.window = NULL
    self.context = NULL
    return self
end

function Sdl:initialize()
    if sdl.SDL_GL_GetCurrentWindow() or sdl.SDL_GetWindowFromID(0) then
        self.window = sdl.SDL_GL_GetCurrentWindow()

        if self.window == NULL then
            self.window = sdl.SDL_GetWindowFromID(0)
        end

        if self.window ~= NULL then
            self.context = sdl.SDL_GL_GetCurrentContext()
            if self.context ~= NULL then
            end
        end
    end

    if self.window == NULL then
        if self.SDL_Init(self.SDL_INIT_EVERYTHING) == 0 then
            self:setCursor(sdl.SDL_SYSTEM_CURSOR_WAIT)

            renderer:load()

            window = self.SDL_CreateWindow('Engine',
                0, 0,
                0, 0,
                renderer.flag +
                self.SDL_WINDOW_RESIZABLE +
--                self.SDL_WINDOW_ALLOW_HIGHDPI +
--                self.SDL_WINDOW_FULLSCREEN +
--                self.SDL_WINDOW_SHOWN +
--                self.SDL_WINDOW_BORDERLESS +
--                self.SDL_WINDOW_MAXIMIZED +
                0)

            if window then
                context = renderer:createContext(window)
                if context then
                    self.window = window
                    self.context = context
                end
            end
        end
    else
        renderer:setVersion()
    end

    if self.window ~= NULL then
        local size = ffi.new('SDL_Rect')
        local displayIndex = 0

        if self.SDL_GetDisplayBounds(displayIndex, size) ~= 0 then
            self.SDL_Log("SDL_GetDisplayBounds failed: %s", self.SDL_GetError())
        end

        print(ffi.string(sdl.SDL_GetDisplayName(displayIndex)))

        if self.context ~= NULL then
            renderer:vsync(1)

            local ddpi, hdpi, vdpi = ffi.new('float[1]'), ffi.new('float[1]'), ffi.new('float[1]')
            self.SDL_GetDisplayDPI(displayIndex,
                ddpi,
                hdpi,
                vdpi)

            self.ddpi, self.hdpi, self.vdpi = ddpi[0], hdpi[0], vdpi[0]
        end
    end

    local _, loaded = pcall(loadstring('return ffi.C.IMG_Load'))
    sdl.image = class 'SdlImage' : meta(not loaded and not ios and (ffi.load('SDL2_image') or Library.load('SDL2_image')) or ffi.C)
end

function Sdl:setWindowTitle(title)
    self.SDL_SetWindowTitle(self.window, title)
end

function Sdl:setWindowSize(screen)
    self.SDL_HideWindow(self.window)
    do
        self.SDL_SetWindowSize(self.window,
            screen.w,
            screen.h)

        print(            screen.w,
            screen.h)

        self.SDL_SetWindowPosition(self.window,
            sdl.SDL_WINDOWPOS_CENTERED,
            sdl.SDL_WINDOWPOS_CENTERED)
    end

    self.SDL_ShowWindow(self.window)
end

function Sdl:setCursor(cursorId)
    local cursor = sdl.SDL_CreateSystemCursor(cursorId)
    sdl.SDL_SetCursor(cursor)
end

function Sdl:toggleWindowDisplayMode()
    sdl.SDL_SetWindowFullscreen(sdl.window, sdl.SDL_WINDOW_FULLSCREEN)
end

function Sdl:release()
    if self.context then
        renderer:deleteContext(self.context)
        self.context = NULL

        if self.window then
            self.SDL_DestroyWindow(self.window)
            self.window = NULL
        end
        renderer:unload()
    end
    self.SDL_Quit()
end

function Sdl:mapKey(key, mode)
    return key
end

function Sdl:scancode2key(event)
    local key = ffi.string(self.SDL_GetScancodeName(event.key.keysym.scancode))
    if key:len() <= 1 then
        key = ffi.string(self.SDL_GetKeyName(event.key.keysym.sym))
    end
    key = key:lower()
    key = self:mapKey(key, true)
    return key
end

local event = ffi.new('SDL_Event')
function Sdl:event()
    while self.SDL_PollEvent(event) == 1 do
        if event.type == self.SDL_WINDOWEVENT then
            if event.window.event == self.SDL_WINDOWEVENT_CLOSE then
                quit()

--            elseif event.window.event == sdl.SDL_WINDOWEVENT_SIZE_CHANGED then
            end

        elseif event.type == self.SDL_KEYDOWN or event.type == sdl.SDL_TEXTINPUT then
            Engine.keypressed(self:scancode2key(event), event.key.isrepeat)

        elseif event.type == sdl.SDL_KEYUP then
            Engine.keyreleased(self:scancode2key(event))

        elseif event.type == sdl.SDL_MOUSEBUTTONDOWN then
            if (event.button.button == self.SDL_BUTTON_LEFT or 
                event.button.button == self.SDL_BUTTON_RIGHT)
            then
                Engine.mousepressed(
                    event.button.x, event.button.y,
                    event.button.button, true,
                    event.button.clicks)
            else
                Engine.buttondown(event.button.button)
            end

        elseif event.type == sdl.SDL_MOUSEMOTION then
            local isTouch = bitAND(event.motion.state, self.SDL_BUTTON_LMASK + self.SDL_BUTTON_RMASK)            
            Engine.mousemoved(
                event.motion.x, event.motion.y,
                event.motion.xrel, event.motion.yrel,
                isTouch)

        elseif event.type == sdl.SDL_MOUSEBUTTONUP then
            if (event.button.button == self.SDL_BUTTON_LEFT or 
                event.button.button == self.SDL_BUTTON_RIGHT)
            then
                Engine.mousereleased(
                    event.button.x, event.button.y,
                    event.button.button, false,
                    event.button.clicks)
            else
                Engine.buttonup(event.button.button)
            end

        elseif event.type == sdl.SDL_MOUSEWHEEL then
            Engine.wheelmoved(event.wheel.x, event.wheel.y)

        elseif event.type == sdl.SDL_MULTIGESTURE then
            if event.mgesture.numFingers == 3 then
                loadApp('apps', 'apps')
            end

        elseif event.type == sdl.SDL_FINGERDOWN then
        end
    end
end

function Sdl:keys2SDL(keys)
    local newKeys = {}

    for k,v in pairs(keys) do
        local scanName = sdl.SDL_GetScancodeName(sdl.scancode[k])

        if scanName ~= k then
            newKeys[scanName] = v
        end
    end

    table.addKeys(keysKeys, newKeys)
end

function Sdl:isDown(key)
    local scanCode = self.SDL_GetScancodeFromName(key)

    keysState = self.SDL_GetKeyboardState(nil)
    return keysState[scanCode] == 1 and true or false
end

function Sdl:isButtonDown(button)
    return hasbit(self.SDL_GetMouseState(nil, nil), 2^(button-1))
end

function Sdl:loadWav(file)
    local wavspec = ffi.new('SDL_AudioSpec[1]')
    
    local wavbuf = ffi.new('uint8_t*[1]')
    local wavlen = ffi.new('uint32_t[1]')

    wavspec = sdl.SDL_LoadWAV_RW(sdl.SDL_RWFromFile(file, "rb"), 1, wavspec, wavbuf, wavlen)
    return wavspec, wavbuf, wavlen
end

function Sdl:getTicks()
    return sdl.SDL_GetTicks()
end

function Sdl:loadImage(path)
    if sdl.image.IMG_Load then
        return sdl.image.IMG_Load(path)
    end
end
