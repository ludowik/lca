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
