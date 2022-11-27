-- A simple circular progress indicator

Progress = class()

function Progress:init()
    -- you can accept and set parameters here
    self.mesh = mesh()
    self.pos = vec2(0,0)
    self.size = 100
    self.color = color(255, 0, 126, 255)
    self.progress = 0
    self.rectIndex = self.mesh:addRect(0,0,self.size,self.size)
    self.mesh.shader = shader(asset.builtin.Patterns.Arc)
end

function Progress:draw()

    self.mesh:setRect(self.rectIndex, 0,0,self.size,self.size)

    local x = 1 - (self.progress*2)

    -- Setup the shader uniforms
    self.mesh.shader.a2 = -math.pi
    self.mesh.shader.color = vec4(self.color.r/255, self.color.g/255,
                                  self.color.b/255, self.color.a/255)
    self.mesh.shader.size = 0.4
    self.mesh.shader.a1 = x * math.pi

    pushMatrix()

    translate(self.pos:unpack())

    self.mesh:draw()

    popMatrix()

end
