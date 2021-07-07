function setup() end
function update() end
function draw() end
function keyboard() end

function love.load()
    local dx, dy = 0, 0
    if os.name == 'ios' then
        W = love.graphics.getWidth()
        H = love.graphics.getHeight()

        W, H = math.min(W,H), math.max(W,H)

        fullscreen = true
        fullscreentype = 'exclusive'
        highdpi = true

    else
        W, H = 600, 900

        fullscreen = false
        fullscreentype = 'desktop'
        highdpi = true
    end

    if W > H then
        dx, dy = 50, 0
    else
        dx, dy = 0, 50
    end

    log(W, H)

    love.window.setMode(W, H, {
            fullscreen = fullscreen,
            fullscreentype = fullscreentype, -- 'desktop', 'exclusive'

            vsync = true,
            -- msaa = 1, -- number of antialiasing samples

            resizable = false,
            borderless = false,

            centered = true,

            -- x = 0,
            -- y = 0,

            -- display = 0, -- index of the display to show the window in, if multiple monitors are available
            -- minwidth	= 100, -- minimum width of the window, if it's resizable
            -- minheight = 100, -- minimum height of the window, if it's resizable
            highdpi = highdpi,
        })

    setupClasses()

    Window(env, dx, dy)
    Fps(0, 50)
    Console(0, 50)

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
        os.exit(0)
    elseif key == 'r' then
        love.event.quit('restart')
    else
        env.keyboard(key)
    end
end
