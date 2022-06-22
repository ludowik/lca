function setup()
    parameter.watch('#app.emitter.particles')

    env.emitter = Emitter()
    
    env.scene = Scene()
    env.scene:add(env.emitter)
end

function touched(touch)
    app.emitter:touched(touch)
end
