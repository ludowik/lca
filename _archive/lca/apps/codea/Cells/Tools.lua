local properties = {
    "__className",
    "label",
    "position",
    "target",
    "size"
}

function show(o, x, y)
    if o[show] then return end
    o[show] = true

    x = x or 10
    y = y or (H-layout.safeArea.top)

    fill(255)
    fontSize(12)
    textMode(CORNER)

    local w, h, th = 0, 0, 0

    for i,v in ipairs(o) do
        w, h = textSize(tostring(i))
        th = th + h
        y = y - h
        text(i..":", x, y)

        if type(v) == "table" then
            h = show(v, x+25, y+h)
            th = th + h
            y = y - h
        end
    end

    for i,k in ipairs(properties) do
        if o[k] then
            w, h = textSize(k)
            th = th + h
            y = y - h
            text(k.."="..tostring(o[k]), x, y)

            if type(o[k]) == "table" then
                h = show(o[k], x + 25, y)            
                th = th + h 
                y = y - h
            end
        end
    end

    o[show] = nil

    return th  
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
                    result = v
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
