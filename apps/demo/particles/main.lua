function setup()
    parameter.watch('#env.emitter.particles')

    env.emitter = Emitter()
    
    env.scene = Scene()
    env.scene:add(env.emitter)
end

function update(dt)
    env.scene:update(dt)
end

function draw()
    env.scene:draw()
end

function touched(touch)
    env.emitter:touched(touch)
end
