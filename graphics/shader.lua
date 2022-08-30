class 'Shader'

function Shader.setup()
    GL_VERTEX_SHADER = 'GL_VERTEX_SHADER'
    GL_FRAGMENT_SHADER = 'GL_FRAGMENT_SHADER'    
end

function Shader:init(name)
    self.name = tostring(name or 'graphics/shaders/default')
    
    self:compile()
end

function Shader:complete(shaderType, source)
    return source
end

function Shader:compile()
    print('compile shader '..self.name)
    
    local vertexShader = (
        io.read(self.name..'.vertex') or
        io.read(self.name..'.ver') or
        io.read('graphics/shaders/default/_shadertoy.vertex'))
    
    local fragmentShader = (
        io.read(self.name) or
        io.read(self.name..'.fragment') or
        io.read(self.name..'.frag') or
        io.read(self.name..'.glsl'))
    
    if vertexShader then
        vertexShader = self:complete(GL_VERTEX_SHADER, vertexShader)
    end
    
    if fragmentShader then
        fragmentShader = self:complete(GL_FRAGMENT_SHADER, fragmentShader)
    end
    
    if vertexShader or fragmentShader then
        self.shader = love.graphics.newShader(vertexShader, fragmentShader)
    end
end

class 'Shaders' : extends(table)

function Shaders.setup()
    shaders = Shaders()
    
    shaders.default = Shader()
    shaders.terrain = Shader()
    shaders.terrain2d = Shader()
    shaders.rect = Shader()
    shaders.model3d = Shader()
end
