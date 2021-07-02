function setup() end
function update() end
function draw() end
function keyboard() end

function love.load()
    love.window.setMode(800, 600, {
            fullscreen = false, -- true for fullscreen
            fullscreentype = 'desktop', -- 'exclusive' or 'normal'
            vsync = false,
            --msaa = 1, -- number of antialiasing samples
            resizable = false,
            borderless = false,
            centered = true,
            -- x = 0,
            -- y = 0,
            --display = 0, -- index of the display to show the window in, if multiple monitors are available
            -- minwidth	= 100, -- minimum width of the window, if it's resizable
            -- minheight = 100, -- minimum height of the window, if it's resizable
            highdpi = false,
        })

    setupClasses()

    W = love.graphics.getWidth()
    H = love.graphics.getHeight()

    Window(env)
    Fps()
    Console()

    print(love.filesystem.getSaveDirectory())

    env.setup()
end

function love.update(dt)
    WindowsManager.update(dt)
end

function love.draw()
    WindowsManager.draw()
end

function love.keypressed(key, scancode, isrepeat)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'r' then
        love.event.quit('restart')
    else
        env.keyboard(key)
    end
end
