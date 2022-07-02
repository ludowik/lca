local __random = math.random

seed = math.randomseed

function random(min, max)
    if not max then
        if not min then
            return __random()
        else
            min, max = 0, min
        end
    end

    return __random() * (max - min) + min
end

randomInt = love.math.random

noise = love.math.noise

local function isinteger(val)
    return val == math.floor(val)
end

class 'Random'

function Random.test()
    assert(seed)
    assert(random)
    assert(randomInt)

    for i=1,10000 do
        assert(randomInt(1) == 1)
        assert(isinteger(randomInt(10^6)) == true)
        assert(isinteger(random(10^6)) == false)
    end
end
