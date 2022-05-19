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