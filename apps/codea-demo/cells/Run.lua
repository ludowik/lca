local who
function touched(touch)
    if touch.state == BEGAN then
        who = command(scene, touch) 
        if who then
            return
        end
        
    elseif who then
        command(table{who}, touch)
        if touch.state == ENDED then
            who = nil
        end
        return
    end
    
    if touchedApp then
        touchedApp(touch)
    end
end
