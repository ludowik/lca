function setup()
    setOrigin(BOTTOM_LEFT)
    
    parameter.watch('#env.emitter.particles')

    env.emitter = Emitter()
    
    env.scene = Scene()
    env.scene:add(env.emitter)
end

function update(dt)
    env.scene:update(dt)
end

function draw()
    background()
    env.scene:draw()
end

function touched(touch)
    env.emitter:touched(touch)
end
