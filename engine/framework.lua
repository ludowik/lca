if config.framework == 'love2d' then
    loadLibc = false
else
    loadLibc = true
end

if loadLibc then
    require 'libc.library'
    require 'libc.sdl.sdl'
    require 'libc.opengl.opengl'
    require 'libc.openal.openal'
    require 'libc.freetype.freetype'

    renderer = OpenGL()

    sdl = Sdl()
    sdl:initialize()
-- renderer:initialize()

--    al = OpenAL()
--    al:initialize()

--    FreeType.setup()

--    ft = FreeType()
--    ft:initialize()
end

function isDown(key)
    return love.keyboard.isDown(key)
end

BUTTON_LEFT = 1
BUTTON_RIGHT = 2

function isButtonDown(button)
    return love.mouse.isDown(button)
end

function getFPS()
    return love.timer.getFPS()
end

function restart()
    quit('restart')
end

function quit(...)
    Engine.unload()
    Engine.quit = true
    return love.event.quit(...)
end

function exit()
    os.exit()
end

os.name = (
    (jit and jit.os) or
    (love and love.system.getOS()) or
    (os and os.getenv('OS')) or
    ('osx')):lower():gsub(' ', ''):gsub('_nt', '')

osx = os.name == 'osx'
oswindows = os.name == 'windows'

function pumpEvent(event)
    event = event or love.event
    event.pump()
    for name, a,b,c,d,e,f in event.poll() do
        if name == "quit" then
            if not love.quit or not love.quit() then
                return a or 0
            end
        end
        love.handlers[name](a,b,c,d,e,f)
    end
end

if config.framework == 'love2d' then
    require 'engine.love'

else    
    local function run()
        local graphics = love.graphics
        local event = love.event
        local keyboard = love.keyboard
        local timer = love.timer 
        local math = love.math
        local filesystem = love.filesystem
        local font = love.font
        local mouse = love.mouse
        local image = love.image
        local window = love.window
        local handlers = love.handlers

        love = {    
            run = function () return function () end end,

            setup = function () end,

            filesystem = {
                getWorkingDirectory = function ()
                    if not global.getcwd then 
                        ffi.cdef[[
                            char* _getcwd(char* buffer, size_t size);
                            char* getcwd(char* buffer, size_t size);
                        ]]
                        global.getcwd = (
                            osx and ffi.C.getcwd or 
                            oswindows and ffi.C._getcwd)
                    end

                    local len = 1024
                    local path = ffi.new('char[?]', len)
                    global.getcwd(path, len)

                    return ffi.string(path)
                end,

                getSaveDirectory = filesystem.getSaveDirectory,
                getDirectoryItems = filesystem.getDirectoryItems,

                getInfo = filesystem.getInfo,

                load = filesystem.load,
                save = filesystem.save,

                read = filesystem.read,
                write = filesystem.write,

                createDirectory = filesystem.createDirectory,
            },

            font = {
                newFont = font.newFont,
                newRasterizer = font.newRasterizer,
            },

            window = {
                setTitle = window.setTitle,
                setVSync = window.setVSync,
                getSafeArea = window.getSafeArea,
                toPixels = window.toPixels,
                setMode = window.setMode,
                minimize = window.minimize,
                restore = window.restore,
            },

            event = love.event,

            handlers = love.handlers,

            mouse = {
                getPosition = mouse.getPosition,
                isDown = mouse.isDown,
            },

            image = {
                newImageData = image.newImageData,
            },

            graphics = {
                replaceTransform = graphics.replaceTransform,
                applyTransform = graphics.applyTransform,

                setDepthMode = graphics.setDepthMode,
                setMeshCullMode = graphics.setMeshCullMode,
                setFrontFaceWinding = graphics.setFrontFaceWinding,
                setBlendMode = graphics.setBlendMode,
                setColor = graphics.setColor,
                setWireframe = graphics.setWireframe,

                newFont = graphics.newFont,
                setFont = graphics.setFont,
                getFont = graphics.getFont,
                newText = graphics.newText,

                newCanvas = graphics.newCanvas,
                setCanvas = graphics.setCanvas,
                getCanvas = graphics.getCanvas,

                newMesh = love.graphics.newMesh,
                newImage = graphics.newImage,

                newShader = graphics.newShader,
                setShader = graphics.setShader,
                getShader = graphics.getShader,
                _shaderCodeToGLSL = graphics._shaderCodeToGLSL,
                getSupported = graphics.getSupported,
                isGammaCorrect = graphics.isGammaCorrect,

                clear = graphics.clear,
                origin = graphics.origin,
                draw = graphics.draw,

                setScissor = graphics.setScissor,
                setPointSize = graphics.setPointSize,
                setLineWidth = graphics.setLineWidth,
                setLineStyle = graphics.setLineStyle,
                points = graphics.points,
                line = graphics.line,
                rectangle = graphics.rectangle,
                circle = graphics.circle,
                ellipse = graphics.ellipse,
                polygon = graphics.polygon,
            },

            math = {
                newTransform = math.newTransform,
            },

            keyboard = {
                setTextInput = keyboard.setTextInput,
                getTextInput = keyboard.getTextInput,
                hasTextInput = keyboard.hasTextInput,
                isDown = keyboard.isDown,
            },

            timer = {
                sleep = timer.sleep,
                
                step = function ()
                    if global.__time1 == nil then
                        global.__time1 = love.timer.getTime()
                        global.__frame = 0
                        global.__deltaTime = 0
                        global.__totalTime = 0
                    end
                    global.__time2 = love.timer.getTime()
                    global.__deltaTime = global.__time2 - global.__time1
                    global.__totalTime = global.__totalTime + global.__deltaTime
                    global.__frame = global.__frame + 1
                    global.__time1 = global.__time2
                end,
                getDelta = function ()
                    return global.__deltaTime
                end,
                getFPS = function ()
                    return _G.math.floor(1 / (global.__totalTime / global.__frame))
                end,
                getTime = function ()
                    local socket = require 'socket'
                    return socket.gettime()
                end,
            },
        }

        Engine.load()

        while not Engine.quit do
            sdl:event()

            -- Update dt, as we'll be passing it to update
            local dt
            if love.timer then
                love.timer.step()
                dt = love.timer.getDelta()
            end

            -- Call update and draw
            Engine.update(dt)

            if graphics and graphics.isActive() then
                graphics.clear(graphics.getBackgroundColor())
                graphics.origin()

                Engine.draw()
            end

--            if love.timer then love.timer.--sleep(0.001) end
        end
    end

    run()
end
