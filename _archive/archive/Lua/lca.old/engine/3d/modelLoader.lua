function loadObj(fileName)
    local filePath = getModelPath()..'/'..fileName..'.obj'
    local content = fs.read(filePath)

    if content then
        content = content:replace('  ', ' ')

        local indices = {}
        local vertices, verticesTemp = {}, {}
        local normals, normalsTemp = {}, {}
        local texCoords, texCoordsTemp = {}, {}

        local lines = content:split('\n')
        for line=1,#lines do
            local datas = lines[line]:trim():split(' ')

            local typeOfRecord = datas[1]

            if typeOfRecord == 'o' then
                -- object name
            elseif typeOfRecord == 'g' then
                -- group name
            elseif typeOfRecord == 'usemtl' then
                -- material name
            elseif typeOfRecord == 'v' then
                -- vertex
                table.insert(verticesTemp, vector(
                        tonumber(datas[2]),
                        tonumber(datas[3]),
                        tonumber(datas[4])
                    ))
            elseif typeOfRecord == 'vn' then
                -- normals
                table.insert(normalsTemp, vector(
                        tonumber(datas[2]),
                        tonumber(datas[3]),
                        tonumber(datas[4])
                    ))
            elseif typeOfRecord == 'vt' then
                -- texture coordinates
                table.insert(texCoordsTemp, vector(
                        tonumber(datas[2]),
                        tonumber(datas[3])
                    ))
            elseif typeOfRecord == 'f' then
                -- faces
                local function vertex(i)
                    assert(tonumber(datas[i][1]), 'line '..line)
                    
                    local n = #vertices+1
                    if #verticesTemp > 0 then
                        vertices[n] = verticesTemp[tonumber(datas[i][1])]
                    end
                    if #texCoordsTemp > 0 then
                        texCoords[n] = texCoordsTemp[tonumber(datas[i][2])]
                    end
                    if #normalsTemp > 0 then
                        normals[n] = normalsTemp[tonumber(datas[i][3])]
                    end
                end

                local function face(a, b, c)
                    vertex(a)
                    vertex(b)
                    vertex(c)
                end

                -- f v1/vt1/vn1 v2/vt2/vn2 v3/vt3/vn3 ...
                for i=2,#datas do
                    datas[i] = datas[i]:trim():split('/')
                end

                if #datas <= 5 then
                    face(3, 4, 2)
                    if #datas == 5 then
                        face(2, 4, 5)
                    end
                else
                    for i=3,#datas-1 do
                        face(i, i+1, 2)
                    end
                end
            end
        end

        local m = Mesh()
        m.indices = indices
        m.vertices = vertices
        m.normals = normals
        m.textCoords = textCoords

        return m
    end
end