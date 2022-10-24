requireLib(
    'lexer',
    'parser')

function setup()
    local files = dirr('engine', isLuaFile)
    for i,file in ipairs(files) do
        print(file)
        lexer(love.filesystem.read(file))
    end
end
