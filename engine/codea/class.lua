-- class
local __class = class
class = function (...)
    local k = __class('Codea'..id())
    for _,base in ipairs({...}) do
        k:extends(base)
    end
    return k
end
