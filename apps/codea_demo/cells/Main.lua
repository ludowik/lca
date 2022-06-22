env.scale = 2

function setup()
--    viewer.mode = FULLSCREEN
    
    state = "pause"
    
    scene = table()
    
    ship = Ship()  
    scene:add(ship)

    weapons = table()
    scene:add(weapons)
    
    scene:add(Wave())
    
    ufos = table()
    scene:add(ufos)
    
    bullets = table()
    scene:add(bullets)
    
    ui = Menu()
    scene:add(ui)

    weapons:add(Weapon())
    weapons:add(Weapon())
    weapons:add(Weapon())
    weapons:add(Weapon())
    
    initMenu()
end

function initMenu()
    ui:clear()
    ui:add(Command(" ", function ()
        ui:clear()
        ui:add(Slider("cadence"))
        ui:add(Show("#ui"))
        ui:add(Command("show", function ()
            config.show = not config.show
            config.save()
        end))
        ui:add(Command("close", function ()
            initMenu()
        end))
        ui:add(Command("quit", function ()
            viewer.close()
        end))
        
    end))
end

function removeDead(t)
    parcours(t, function (t, i, v)
        if v.state == "dead" then
            t:remove(i)
            v:destroy()
        end
    end)
end

function command(t, touch)
    local result = false
    parcours(t, function (t, i, v)
        if v and v.touched then
            if v:contains(touch) then
                v:touched(touch)
                result = true
            end
        end
    end)
    return result
end

function parcours(t, f)
    for i=#t,1,-1 do
        local v = t[i]
        if v and #v > 0 then
            parcours(v, f)
        else
            f(t, i, v)
        end
    end
end

function update(dt)
    if state == "pause" then
        ui:update(dt)
        return
    end
    
    scene:update(dt)
    
    Cell.collisions(bullets, ufos)
    Cell.collisions({ship}, weapons)  
    removeDead(scene)
end

function draw()
    update(deltaTime)
    
    background(51)
    scene:draw()
    
    if config.show then
        show(scene)
    end
end

function touchedApp(touch)
    if touch.state == BEGAN then
        ship.offset = vec2(touch.x, touch.y) - ship.position
        state = "active"
    end
    
    if state == "active" then
        if touch.state == CHANGED then
            ship.target = vec2(touch.x, touch.y)
            
        elseif touch.state == ENDED then
            ship.target = nil
            ship.linearVeolcity = vec2()
            state = "pause"
        end
    end
end
