-- TableEx.lua
-- contains various useful functions related to tables
TableEx = class()

function TableEx.remove(array,obj,allInstances)
    local n = #array
    for i = n,1,-1 do
        if array[i] == obj then
            table.remove(array,i)
            if not allInstances then return nil end
        end
    end
end

-- shallow clone the array
function TableEx.clone(array)
    local clone = {}
    for _,elem in ipairs(array) do table.insert(clone,elem) end
    return clone
end

-- applyes this func to all elems of the second argument, which is an array
-- func should take as many arguments as the number of arrays that are passed in
function TableEx.map(func,...)
	local argn = select('#', ...)
	local arg = {...}
    assert(argn > 0,"TableEx.map called with no arguments")
    local result = {}
    local n = #arg[1]
    for i = 1,n do
        -- fixme: isn't there a function that does this for me?
        local args = {}
        for _,arr in ipairs(arg) do table.insert(args,arr[i]) end
        local r = func(unpack(args))
        table.insert(result,r)
    end
    return result
end

function TableEx.random(array)
    local n = #array
    local r = math.random(n)
    return array[r]
end

function TableEx.contains(array,obj)
    for _,elem in ipairs(array) do
        if elem == obj then return true end
    end
    return false
end
    
function TableEx.size(tab)
    local n = 0
    for k,v in pairs(tab) do n = n + 1 end
    return n
end