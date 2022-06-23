if love then
    seed = love.math.setRandomSeed
    random = love.math.random
    randomInt = love.math.random
    noise = love.math.noise
else
    seed = math.randomseed
    random = math.random
    noise = math.random
end

function random(min, max)
    if not max then
        if not min then
            return love.math.random()
        else
            min, max = 0, min
        end
    end

    return love.math.random() * (max - min) + min
end
