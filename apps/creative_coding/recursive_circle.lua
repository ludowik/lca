function setup()
    env.angle = 0
    colorMode(HSB, 1)
    
    parameter.boolean('inColor', true)
end

function update(dt)
    env.angle = env.angle + dt
end

function render(x, y, radius, level)
    level = level or 0
    
    if radius <= 3 then return end
    
    pushMatrix()
    translate(x, y)
    rotate(env.angle * (level % 2 and -1.5 or 1))
    if inColor then
        fill(level % 2 and radius / (W / 2) or 1 - radius / (W / 2), 0.5, 1)
    else
        fill(level % 2 and 1 or 0)
    end
    circle(0, 0, radius)
    level = level + 1
    render(- radius / 2, 0, radius / 2, level)
    render(  radius / 2, 0, radius / 2, level)
    render(0, - radius * 2 / 3, radius / 3, level)
    render(0,   radius * 2 / 3, radius / 3, level)
    popMatrix()
end

function draw()
    background(colors.green)
    noStroke()
    env.render(X+W/2, Y+H/2, W/2)
end
