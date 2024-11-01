class 'Graphics3d'

function Graphics3d.setup()
    meshAxesX = Model.cylinder(1, 1, 10000):center()
    meshAxesX:setColors(red)
    meshAxesX.shader = shaders.default

    meshAxesY = Model.cylinder(1, 1, 10000):center()
    meshAxesY:setColors(green)
    meshAxesY.shader = shaders.default

    meshAxesZ = Model.cylinder(1, 1, 10000):center()
    meshAxesZ:setColors(blue)
    meshAxesZ.shader = shaders.default
end

function MeshAxes(x, y, z)
    x, y, z = xyz(x, y, z)

    pushMatrix()
    do
        translate(x, y, z)

        scale(0.01, 0.01, 0.01)

        rotate(90, 0, 1, 0)
        meshAxesX:draw()

        rotate(-90, 1, 0, 0)
        meshAxesY:draw()

        rotate(90, 0, 1, 0)
        meshAxesZ:draw()
    end
    popMatrix()
end
