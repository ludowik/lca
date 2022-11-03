function setup()
    devices = love.audio.getRecordingDevices()
    device = devices[1]
    status = device:start(2048)

    buffer = table()

    parameter.watch('#devices')
    parameter.watch('status')
    parameter.watch('#buffer')    
    
    parameter.integer('mode', 1, 2, 1)
end

function pause()
    status = device:stop()
end

function resume()
    status = device:start(2048)
end

function update(dt)
    data = device:getData()
    while data do
        for i=0,data:getSampleCount()-1 do
            buffer:add(data:getSample(i))
        end
        data = device:getData()
    end

    while #buffer > W do
        buffer:remove(1)
    end
end

function draw()
    background()

    local arrays = table()
    local size = min(W, H) / 4
    local n = #buffer

    for i=1,n do
        local len = buffer[i]

        local x, y
        if mode == 1 then
            x = W/2 + cos(TAU*i/n) * map(len, -1, 1, 0, size*3)
            y = H/2 + sin(TAU*i/n) * map(len, -1, 1, 0, size*3)
        else
            x = i
            y = H/2 + len
        end

        table.insert(arrays, x)
        table.insert(arrays, y)
    end

--    for x=1,1000 do
--        table.insert(arrays, x)
--        table.insert(arrays, H/2 + random() * noise(elapsedTime + x / 10) * size)
--    end

noFill()

    polygon(arrays)
end
