abs = math.abs

function math.sign(value)
    if value > 0 then
        return 1
    elseif value < 0 then
        return -1
    else
        return 0
    end
end
sign = math.sign

min, max = math.min, math.max

DEGREES = 'degrees'
RADIANS = 'radians'

PI = math.pi
TAU = math.pi * 2

local __angleMode = RADIANS
function angleMode(mode)
    if mode then 
        __angleMode = mode
    end
    return __angleMode
end
