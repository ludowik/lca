class 'Mesh'

function Mesh.setup()
    GL_TRIANGLE_STRIP = 'triangles'
end

function Mesh:init(vertices)
    self.vertices = vertices
end

function Mesh:render()
end
