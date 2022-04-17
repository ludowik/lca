nilf = function() end 

setup = setup or nilf
update = update or nilf
draw = draw or nilf

function makelove()
    os.execute('makelove')
    os.execute('unzip -o -u makelove-build/lovejs/lca-lovejs.zip')
    os.execute('python3 -m http.server 8080 --directory lca')
end

function love.load()
    makelove()
    
    W, H = love.graphics.getDimensions()
    setup()
end

function love.update(dt)
    update(dt)
end

function love.draw()
    draw()
end

function love.keyreleased(key)
    if key == 'escape' then love.event.quit() end
end
