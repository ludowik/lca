-- export global variable
local __g = _G
global = {}
setmetatable(global, {
    __newindex = function(_, name, value)-- If you need to assign a global variable, such as a=2, Need to be written cc.exports.a=2
        rawset(__g, name, value)         -- adopt __newindex Meta methods will be used for cc.exports The assignment of is changed to _G Assignment , So it's not cc.exports assignment 
    end,                                 -- Therefore, when accessing , Direct access _G that will do :print(a)  -- Print 2

    __index = function(_, name)
        return rawget(__g, name)-- adopt __index Meta methods will be used for cc.exports A visit to _G The interview of 
    end
})

-- disable create unexpected global variable
function disableGlobal()
    setmetatable(__g, {
        __newindex = function(_, name, value)-- Once the global environment is assigned, it will call the... Set here __newindex Metamethod , Prompt error , Assignment is not performed 
            print(string.format("Use 'global.%s = value' instead of set global variable", name))
            rawset(__g, name, value)
            assert()
        end
    })
end
