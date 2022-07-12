function scanTODO()
    local function scan(todos)
        local todoLists = {}
        for _,todoName in ipairs(todos) do
            todoLists[todoName] = table()
        end

        local list = dirr('')
        for i,file in ipairs(list) do

            if isLuaFile(file) then
            
                local content = io.read(file)
                if content then

                    local lines = content:split(NL)
                    if lines then
                        for iline,line in ipairs(lines) do

                            for _,todoName in ipairs(todos) do
                                local i,j,v = line:find('([ -]'..todoName..'[ :]*.*)')
                                if i then
                                    local ref = file -- :gsub(Path.sourcePath..'/', '')
                                    todoLists[todoName]:insert(ref..':'..iline..': '..v)
                                end
                            end

                        end
                    end
                end

            end
        end
        
        for _,todoName in ipairs(todos) do
            if #todoLists[todoName] > 0 then
                local data = todoLists[todoName]:concat(NL)

                print(todoName)
                print(data)

                io.write('todo', data, 'at')
            end
        end
    end

    io.write('todo', '', 'wt')

    scan{
        'TODO',
        'TODEL',
        'TOFIX',
        'TOTEST'
    }

    exit()
end
