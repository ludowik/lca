local __min, __max, __floor, __ceil  = math.min, math.max, math.floor, math.ceil

min, max = math.min, math.max

math.maxinteger =  2^52
math.mininteger = -2^52

math.MAX_INTEGER = math.maxinteger
math.MIN_INTEGER = math.mininteger

abs = math.abs

floor, ceil = math.floor, math.ceil

pow, sqrt = math.pow, math.sqrt

PI = math.pi
TAU = math.pi * 2

cos, sin = math.cos, math.sin
rad, deg = math.rad, math.deg

tan, atan, atan2 = math.tan, math.atan, math.atan2

function ceil(num, idp)
    idp = idp or 0
    local mult = 10^idp
    return __ceil(num * mult) / mult
end

function floor(num, idp)
    idp = idp or 0
    local mult = 10^idp
    return __floor(num * mult) / mult
end

function math.round(num, idp)
    idp = idp or 0
    local mult = 10^idp
    return __floor(num * mult + 0.5) / mult
end
round = math.round

local __clamp
function math.clamp(value, _min, _max)
    return __min(__max(value, _min), _max)
end
clamp, __clamp = math.clamp, math.clamp

function math.map(value, min_in, max_in, min_out, max_out)
    if min_in == max_in then
        return max_out
    end

    value = __clamp(value, min_in, max_in)
    value = (value - min_in) * (max_out - min_out) / (max_in - min_in) + (min_out)

    return value
end
map = math.map

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

function math.quotient(dividend, divisor)
    return __ceil(dividend / divisor)
end
quotient = math.quotient

function math.fract(x)
    return x - floor(x)
end
fract = math.fract
