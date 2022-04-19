if love then
    os.name = love.system.getOS():lower():gsub(' ', '')
else
    os.name = os.getenv('OS')
end

print('os.name: '..os.name)
