requireLib(
    'lexer',
    'parser')

function setup()
    local files = dir('engine', isLuaFile, true)
    for i,file in ipairs(files) do
        print(file)
        lexer(io.read('engine/'..file))
    end
end
