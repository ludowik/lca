class 'Shader'

function Shader.setup()
    GL_VERTEX_SHADER = 'GL_VERTEX_SHADER'
    GL_FRAGMENT_SHADER = 'GL_FRAGMENT_SHADER'    
end

function Shader:init(name, path)
    self.name = tostring(name or 'default')
    self.path = tostring(path or 'graphics/shaders')

    self.uniforms = {}

    self:compile()
end

function Shader:complete(shaderType, source)
    local includes =
    (
        io.read(self.path..'/'..'_include.glsl')..
        io.read(self.path..'/'..'_math.glsl')..
        io.read(self.path..'/'..'_noise2D.glsl')..
        io.read(self.path..'/'..'_noise3D.glsl')
    )

    source = (
        '#pragma language glsl3'..NL..
        includes..NL..
        source)
    
    return source
end

function Shader:compile()
    print('compile shader '..self.name)

    local vertexShader = (
        io.read(self.path..'/'..self.name) or
        io.read(self.path..'/'..self.name..'.vertex') or
        io.read(self.path..'/'..'default.vertex'))

    local fragmentShader = (
        io.read(self.path..'/'..self.name) or
        io.read(self.path..'/'..self.name..'.fragment') or
        io.read(self.path..'/'..self.name..'.frag') or
        io.read(self.path..'/'..self.name..'.glsl') or
        io.read(self.path..'/'..'default.fragment'))

    if vertexShader then
        vertexShader = self:complete(GL_VERTEX_SHADER, vertexShader)
    end

    if fragmentShader then
        fragmentShader = self:complete(GL_FRAGMENT_SHADER, fragmentShader)
    end

    if vertexShader or fragmentShader then
        io.write('_shader.vertex', vertexShader)
        io.write('_shader.fragment', fragmentShader)
        
        self.shader = love.graphics.newShader(fragmentShader, vertexShader)
    end
end

class 'Shaders' : extends(table)

function Shaders.setup()
    shaders = Shaders()

    shaders.default = Shader()
    shaders.terrain = shaders.default
    shaders.terrain2d = shaders.default
    shaders.rect = shaders.default
    shaders.model3d = shaders.default
    
    shaders.light = Shader('light')    
end
