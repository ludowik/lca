function setup()    
    local str = io.read('res/map/uga.geojson')
    map = json.decode(str)

    minx = math.maxinteger
    miny = math.maxinteger

    maxx = -math.maxinteger
    maxy = -math.maxinteger

    ugas = table()
    for i,feature in ipairs(map.features) do
        beginShape()
        for _,v in ipairs(feature.geometry.coordinates[1][1]) do
            local lon = v[1]
            local lat = v[2]
            
            x, y = latLonToOffsets(lat, lon, W/2, W/2)
            
            minx = min(minx, x)
            miny = min(miny, y)

            maxx = max(maxx, x)
            maxy = max(maxy, y)
            
            vertex(x, y)
        end
        local shape = endShape(CLOSE)

        ugas:add(shape)
    end
    
    scalex = (maxx - minx)
    scaley = (maxy - miny)
    
    position = vec2()
    
    print(minx, miny, maxx, maxy, scalex, scaley)

    zoom = 1
end

function draw()
    background()
    
    scale(zoom, zoom)
    translate(position.x, position.y)    
    
    scale(W/scalex, W/scalex)
    translate(-minx, -miny)
    
    strokeSize(scalex/W)
    
    noFill()
    
    ugas:draw()
end

function touched(touch)
    if touch.state == MOVED then
        position:add(vec2(touch.dx, touch.dy))
    end
end

function wheelmoved(dx, dy)
    local ratio = 1.2
    if dy > 0 then
        zoom = zoom * ratio
    else
        zoom = zoom / ratio
    end
end

function latLonToOffsets(latitude, longitude, mapWidth, mapHeight)
    local FE = 180 -- false easting
    local radius = mapWidth / (2 * PI)

    local latRad = rad(latitude)
    local lonRad = rad(longitude + FE)

    local x = lonRad * radius

    local yFromEquator = radius * math.log(math.tan(PI / 4 + latRad / 2))
    local y = mapHeight / 2 - yFromEquator

    return x, y
end
