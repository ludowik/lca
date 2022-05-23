function love.load()
    config = table()

    screen = {
        w = 0,
        h = 0
    }

    safeArea = {}
    if os.name == 'ios' then
        local modes = love.window.getFullscreenModes()
        screen = {
            w = modes[1].width,
            h = modes[1].height
        }

        safeArea.dx, safeArea.dy, safeArea.w, safeArea.h = love.window.getSafeArea()

        safeArea.dx = love.window.toPixels(safeArea.dx)
        safeArea.dy = love.window.toPixels(safeArea.dy)

        safeArea.w = love.window.toPixels(safeArea.w)
        safeArea.h = love.window.toPixels(safeArea.h)

    else -- if os.name == 'ios-osx' then
        local modes = {{width=428,height=926}}
        screen = {
            w = modes[1].width,
            h = modes[1].height
        }

        safeArea.dx = 0
        safeArea.dy = 50

        safeArea.w = screen.w - safeArea.dx * 2
        safeArea.h = screen.h - safeArea.dy * 2

    end

    if os.name == 'ios' then
        screen.w, screen.h = math.min(screen.w, screen.h), math.max(screen.w, screen.h)

        if os.emulation then
            fullscreen = false
        else
            fullscreen = true
        end

        fullscreentype = 'exclusive'
        highdpi = true

    elseif os.name == 'ios-osx' then
        screen.w, screen.h = math.min(screen.w, screen.h), math.max(screen.w, screen.h)

        fullscreen = false
        fullscreentype = 'exclusive'
        highdpi = true

    else
        local scale = 1
        if true then
            screen.w, screen.h = math.min(screen.w, screen.h)*scale, math.max(screen.w, screen.h)*scale
        else
            screen.w, screen.h = math.max(screen.w, screen.h)*scale, math.min(screen.w, screen.h)*scale
        end

        fullscreen = false
        fullscreentype = 'desktop'
        highdpi = true
    end

    log(os.name)
    log(safeArea.dx, safeArea.dy, safeArea.w, safeArea.h, screen.w, screen.h)

    love.window.setMode(screen.w, screen.h,
        {
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
            highdpi = false, -- highdpi,
        })

    love.window.setDisplaySleepEnabled(true)

    setupClasses()

    newHeap('events')
    
    config.fps = {frameTarget = 60}

    WindowsManager.fps = Fps(safeArea.dy, 0)
    WindowsManager.console = Console(0, nil, nil, safeArea.dy*2)

    WindowsManager.menu = Widget()
    WindowsManager.menu.scene:add(Button('Apps', function () loadApp('apps/apps') end))
    WindowsManager.menu.scene:add(Button('Test', function () app.autotest = true end))
    WindowsManager.menu.scene:add(Button('Debug', function () debugStop() end))

    elapsedTime = 0
    deltaTime = 0

    loadApp(db.get('lca', 'appName', 'apps/apps'))

    log(love.filesystem.getSaveDirectory())
end

function redraw()
    app.loop = 'redraw'
end

function noLoop()
    app.loop = 'noloop'
end

function love.update(dt)
    if love.window.getTitle() ~= app.appName then
        love.window.setTitle(app.appName)
    end

    TimerManager.update(dt)

    if app.loop == 'noloop' then return end
    if app.loop == 'redraw' then app.loop = 'noloop' end

    elapsedTime = elapsedTime + dt
    deltaTime = dt

--    TweensManager.update(dt)

--    WindowsManager.update(dt)
    app.win:updateInstance(dt)

    local timer = pop('events')
    if event then
        event()
    end

    local event = pop('events')
    if event then
        event()
    end
end

function love.draw()
--    WindowsManager.draw()
    app.win:drawInstance()

    WindowsManager.fps:drawInstance()
    WindowsManager.console:drawInstance()
    WindowsManager.menu:drawInstance()
end

function quit(mode)
    love.event.quit(mode)
end

function exit(res)
    quit()
    os.exit(res or 0)
end







local utf8 = require("utf8")

local function error_printer(msg, layer)
    print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end

function love.errorhandler(msg)
    msg = tostring(msg)

    error_printer(msg, 2)

    if not love.window or not love.graphics or not love.event then
        return
    end

    if not love.graphics.isCreated() or not love.window.isOpen() then
        local success, status = pcall(love.window.setMode, 800, 600)
        if not success or not status then
            return
        end
    end

    -- Reset state.
    if love.mouse then
        love.mouse.setVisible(true)
        love.mouse.setGrabbed(false)
        love.mouse.setRelativeMode(false)
        if love.mouse.isCursorSupported() then
            love.mouse.setCursor()
        end
    end
    if love.joystick then
        -- Stop all joystick vibrations.
        for i,v in ipairs(love.joystick.getJoysticks()) do
            v:setVibration()
        end
    end
    if love.audio then love.audio.stop() end

    love.graphics.reset()
    local font = love.graphics.setNewFont(14)

    love.graphics.setColor(1, 1, 1, 1)

    local trace = debug.traceback()

    love.graphics.origin()

    local sanitizedmsg = {}
    for char in msg:gmatch(utf8.charpattern) do
        table.insert(sanitizedmsg, char)
    end
    sanitizedmsg = table.concat(sanitizedmsg)

    local err = {}

    table.insert(err, "Error\n")
    table.insert(err, sanitizedmsg)

    if #sanitizedmsg ~= #msg then
        table.insert(err, "Invalid UTF-8 string in error message.")
    end

    table.insert(err, "\n")

    for l in trace:gmatch("(.-)\n") do
        if not l:match("boot.lua") then
            l = l:gsub("stack traceback:", "Traceback\n")
            table.insert(err, l)
        end
    end

    local p = table.concat(err, "\n")

    p = p:gsub("\t", "")
    p = p:gsub("%[string \"(.-)\"%]", "%1")

    local function draw()
        local pos = 70
        love.graphics.clear(89/255, 157/255, 220/255)
        love.graphics.printf(p, pos, pos, love.graphics.getWidth() - pos)
        love.graphics.present()
    end

    local fullErrorText = p
    local function copyToClipboard()
        if not love.system then return end
        love.system.setClipboardText(fullErrorText)
        p = p .. "\nCopied to clipboard!"
        draw()
    end

    if love.system then
        p = p .. "\n\nPress Ctrl+C or tap to copy this error"
    end

    return function()
        love.event.pump()

        for e, a, b, c in love.event.poll() do
            if e == "quit" then
                return 1
            elseif e == "keypressed" and a == "escape" then
                return 1
            elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
                copyToClipboard()
            elseif e == "touchpressed" then
                local name = love.window.getTitle()
                if #name == 0 or name == "Untitled" then name = "Game" end
                local buttons = {"OK", "Cancel"}
                if love.system then
                    buttons[3] = "Copy to clipboard"
                end
                local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
                if pressed == 1 then
                    return 1
                elseif pressed == 3 then
                    copyToClipboard()
                end
            end
        end

        draw()

        if love.timer then
            love.timer.sleep(0.1)
        end
    end

end

local __errorhandler = love.errorhandler

function love.errorhandler(msg)
    if os.name == 'ios' then        
        db.set('lca', 'appName', 'apps/apps')
    end
    return __errorhandler(msg)
end
