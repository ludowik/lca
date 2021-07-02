NL = '\n'

function string:inList(list, ...)
    if type(list) ~= 'table' then
        list = {list, ...}
    end
    for _,str in ipairs(list) do
        if self == str then
            return true
        end
    end
end
