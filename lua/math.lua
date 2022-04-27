min, max = math.min, math.max

abs = math.abs

floor, ceil = math.floor, math.ceil
round = math.floor

pow = math.pow

PI = math.pi
TAU = math.pi * 2

cos, sin = math.cos, math.sin

rad, deg = math.rad, math.deg

local __min, __max = math.min, math.max
function math.clamp(value, _min, _max)
    return __min(__max(value, _min), _max)
end

function math.map(value, min_in, max_in, min_out, max_out)
    if min_in == max_in then
        return max_out
    end

    value = math.clamp(value, min_in, max_in)

    value = (value - min_in) * (max_out - min_out) / (max_in - min_in) + (min_out)

    return value
end
