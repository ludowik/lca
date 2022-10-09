function setup()
    size = 4
    grid = Grid(W/size, H/size, true)    

    position = vec2(grid.n/2, grid.m/2):floor()    
    direction = vec2(0, 1)

    parameter.watch('position')
    parameter.watch('direction')
end

function step()
    local value = grid:get(position.x, position.y) 
    if value then
        direction = vec2(direction.y, -direction.x)
        fill(colors.black)
    else
        direction = vec2(-direction.y, direction.x)
        fill(colors.white)
    end
    
    grid:set(position.x, position.y, not value)    
    rect(position.x*size, position.y*size, size, size)
    
    position = position + direction
end

function draw()
    noStroke()
    rectMode(CENTER)
    
    for i=1,10 do
        step()
    end
end
