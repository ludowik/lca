class 'Model'

function Model.setColors(vertices, clr)
    for i=#vertices-5,#vertices do
        vertices[i][4+2] = clr.r
        vertices[i][5+2] = clr.g
        vertices[i][6+2] = clr.b
        vertices[i][7+2] = clr.a
    end
end

function Model.box(x, y, z, w, h, d)
    local vertices = {}

    -- front
    table.insert(vertices, {x-w, y-h, z-d, 0, 0})
    table.insert(vertices, {x+w, y-h, z-d, 0, 0})
    table.insert(vertices, {x+w, y+h, z-d, 0, 0})
    table.insert(vertices, {x-w, y-h, z-d, 0, 0})
    table.insert(vertices, {x+w, y+h, z-d, 0, 0})
    table.insert(vertices, {x-w, y+h, z-d, 0, 0})
    Model.setColors(vertices, colors.green)

    -- back
    table.insert(vertices, {x+w, y-h, z+d, 0, 0})
    table.insert(vertices, {x-w, y-h, z+d, 0, 0})
    table.insert(vertices, {x-w, y+h, z+d, 0, 0})
    table.insert(vertices, {x+w, y-h, z+d, 0, 0})
    table.insert(vertices, {x-w, y+h, z+d, 0, 0})
    table.insert(vertices, {x+w, y+h, z+d, 0, 0})
    Model.setColors(vertices, colors.yellow)

    -- left
    table.insert(vertices, {x-w, y-h, z+d, 0, 0})
    table.insert(vertices, {x-w, y-h, z-d, 0, 0})
    table.insert(vertices, {x-w, y+h, z-d, 0, 0})
    table.insert(vertices, {x-w, y-h, z+d, 0, 0})
    table.insert(vertices, {x-w, y+h, z-d, 0, 0})
    table.insert(vertices, {x-w, y+h, z+d, 0, 0})
    Model.setColors(vertices, colors.orange)

    -- right
    table.insert(vertices, {x+w, y-h, z-d, 0, 0})
    table.insert(vertices, {x+w, y-h, z+d, 0, 0})
    table.insert(vertices, {x+w, y+h, z+d, 0, 0})
    table.insert(vertices, {x+w, y-h, z-d, 0, 0})
    table.insert(vertices, {x+w, y+h, z+d, 0, 0})
    table.insert(vertices, {x+w, y+h, z-d, 0, 0})
    Model.setColors(vertices, colors.red)

    -- up
    table.insert(vertices, {x-w, y+h, z-d, 0, 0})
    table.insert(vertices, {x+w, y+h, z-d, 0, 0})
    table.insert(vertices, {x+w, y+h, z+d, 0, 0})
    table.insert(vertices, {x-w, y+h, z-d, 0, 0})
    table.insert(vertices, {x+w, y+h, z+d, 0, 0})
    table.insert(vertices, {x-w, y+h, z+d, 0, 0})
    Model.setColors(vertices, colors.white)

    -- down
    table.insert(vertices, {x+w, y-h, z-d, 0, 0})
    table.insert(vertices, {x-w, y-h, z-d, 0, 0})
    table.insert(vertices, {x-w, y-h, z+d, 0, 0})
    table.insert(vertices, {x+w, y-h, z-d, 0, 0})
    table.insert(vertices, {x-w, y-h, z+d, 0, 0})
    table.insert(vertices, {x+w, y-h, z+d, 0, 0})
    Model.setColors(vertices, colors.blue)

    return vertices
end

function Model.computeNormals(vertices, indices, mode)
    local normals = Buffer('vec3')

    local n = indices and #indices or #vertices

    local v12, v13 = vec3(), vec3()

    local v1, v2, v3

    if mode == nil then
        for i=1,n,3 do
            if indices then
                v1 = vertices[indices[i]]
                v2 = vertices[indices[i+1]]
                v3 = vertices[indices[i+2]]
            else
                v1 = vertices[i]
                v2 = vertices[i+1]
                v3 = vertices[i+2]
            end

            v12:set(v2):sub(v1)
            v13:set(v3):sub(v1)

            local normal = v12:crossInPlace(v13):normalizeInPlace()

            normals[i  ] = normal
            normals[i+1] = normal
            normals[i+2] = normal
        end
    else
        for i=1,n-2 do
            if indices then
                v1 = vertices[indices[i]]
                v2 = vertices[indices[i+1]]
                v3 = vertices[indices[i+2]]
            else
                v1 = vertices[i]
                v2 = vertices[i+1]
                v3 = vertices[i+2]
            end

            v12:set(v2):sub(v1)
            v13:set(v3):sub(v1)

            local normal = v12:crossInPlace(v13):normalizeInPlace()
            
            if i%2 == 0 then
                normals[i] = normal
            else
                normals[i] = normal:unm()
            end
        end
    end

    return normals
end
