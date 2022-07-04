__love = love
love = nil

if love then
    os.name = love.system.getOS():lower():gsub(' ', '')
else
    os.name = os.getenv('OS') or 'osx'
end

if love then 
    core = love
    require 'engine.love'

else
    core = {
        filesystem = {
            getInfo = function (name)
                local f = io.open(name, 'r')    
                if f ~= nil then
                    io.close(f)
                    return {}
                end
            end,
        },

        math = {
        },

        event = {
        }
    }

    require 'maths.noise_permutation'

    core.math.noise = noise
end
