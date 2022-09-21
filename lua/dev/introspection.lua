function introspection()
    local env = _G.env

    env.ui = env.ui or UIScene(Layout.row)

    local function addGroup(filterType)
        local group = env.ui:ui(filterType)
        if group == nil then
            group = UIScene(Layout.column)
            env.ui:add(group)
        else
            group:clear()
        end

        local typeFilter = 'number'
        
        local function addRef(k, v)
            if type(v) == filterType then
                if tostring(k):lower() ~= tostring(v):lower() then -- exclude macro
                    local ui = Expression(k, "tostring("..k..")")
                    ui.styles.fontSize = 12
                    group:add(ui)
                end
            end
        end
        
        for k,v in pairs(env) do
            addRef(k, v)
        end
        
        for i,v in ipairs(env) do
            addRef(tostring(i), v)
        end
    end

    addGroup('boolean')
    addGroup('number')
    addGroup('string')
    addGroup('table')
    addGroup('function')
    
    return function ()
        env.ui:draw()
    end    
end
