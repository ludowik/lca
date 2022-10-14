function setup()
    N = 128
    pixelSize = ceil(max(W, H) / N)

    density = Buffer('float'):resize(N*N)
    density_new = Buffer('float'):resize(N*N)

    for y=1,N do
        for x=1,N do
            local i = index(x, y)
            density[i] = noise(
                (x + 8554.25) / 12.45,
                (y + 6945.36) / 12.45) * 2^8
            density_new[i] = 0
        end
    end

    img = Image(N)

    config.interpolate = false

    parameter.boolean('config.interpolate')    
    parameter.watch('total')
end

function index(x, y)
    return x + (y-1) * N
end

function touched(touch)
    local x, y = floor(touch.x/pixelSize), floor(touch.y/pixelSize)
    if x >= 0 and x < N and y >= 0 and y < N then
        density[index(x+1, y+1)] = 2^8
    end
end

function update(dt)
    for y=1,N do
        for x=1,N do
            local i = index(x, y)
            density_new[i] = density[i] + dt * (
                (density[index(x-1, y)] or 0) +
                (density[index(x+1, y)] or 0) +
                (density[index(x, y-1)] or 0) +
                (density[index(x, y+1)] or 0) - 4 * density[i]
            )
        end
    end

    density_new, density = density, density_new

    total = 0
    for i=1,N*N do
        total = total + density[i]
    end

    total = floor(total)
end

function draw()
    for y=1,N do
        for x=1,N do
            local v = map(density[index(x, y)], 0, 255, 0, 1)
            img:set(x-1, y-1, v, v, v, 1)
        end
    end

    scale(pixelSize)

    spriteMode(CORNER)
    sprite(img)
end
