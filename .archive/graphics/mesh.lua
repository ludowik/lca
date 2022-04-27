Mesh = class()

function Mesh:init(vertices, clr)
    self.vertices = vertices or table()
    self.colors = clr and table({clr}) or table({colors.white})
end
