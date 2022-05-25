class 'Graphics3d'

function Graphics3d.setup()
    meshAxesX = Model.cylinder(1, 1, 10000):center()
    meshAxesX:setColors(red)
    meshAxesX.shader = Shader('default')

    meshAxesY = Model.cylinder(1, 1, 10000):center()
    meshAxesY:setColors(green)
    meshAxesY.shader = Shader('default')

    meshAxesZ = Model.cylinder(1, 1, 10000):center()
    meshAxesZ:setColors(blue)
    meshAxesZ.shader = Shader('default')
end

function depthMode(mode)
end

function cullingMode()
end

function lines3D()
end

function plane()
end

function box()
end

function sphere()
end

function pyramid()
end

function light()
end

