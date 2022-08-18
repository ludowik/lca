requireLib(
    'lexer',
    'parser')

function setup()
    local files = dirr('engine', isLuaFile)
    for i,file in ipairs(files) do
        lexer(io.read(file))
    end
end
