function love.load()
    screen = {
        w = 0,
        h = 0
    }

    local dx, dy = 0, 0
    if os.name == 'ios' then
        screen.w = love.graphics.getWidth()
        screen.h = love.graphics.getHeight()

        fullscreen = true
        fullscreentype = 'exclusive'
        highdpi = true

        if screen.w > screen.h then
            dx, dy = 50, 0
        else
            dx, dy = 0, 50
        end

    else
        screen.w, screen.h = 800, 600

        fullscreen = false
        fullscreentype = 'desktop'
        highdpi = true
    end

    log(screen.w, screen.h)

    love.window.setMode(screen.w, screen.h, {
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

    Fps(0, 50)
    Console()

    setActiveApp(loadApp('Apps', 'apps.apps'))
    setActiveApp(loadApp('Apps', 'apps.creativeCoding.colors'))

    log(love.filesystem.getSaveDirectory())
end

function love.update(dt)
    TweensManager.update(dt)
    WindowsManager.update(dt)
end

function love.draw()
    WindowsManager.draw()
end
