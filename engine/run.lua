function setup() end
function update() end
function draw() end
function keyboard() end

function love.load()
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
