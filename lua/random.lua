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

function randomInt(min, max)
    assert(min)
    if not max then min, max = 1, min end
    return math.ceil(random(min-1, max))
end

function randomBoolean()
    return __random() <= 0.5
end


class 'Random'

function Random.test()
    assert(seed)
    assert(random)
    assert(randomInt)

    for i=1,10000 do
        ut.assertBetween('random', random(), 0, 1)
        ut.assertBetween('randomInt', randomInt(1), 0, 1)
        
        assert(isinteger(randomInt(10^6)) == true)
        assert(isinteger(random(10^6)) == false)
    end
end
