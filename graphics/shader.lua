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
    local noise = ''
    
--    (
--        io.read(self.path..'/_include.glsl')..NL..
--        io.read(self.path..'/_noise2D.glsl')..NL..
--        io.read(self.path..'/_noise3D.glsl'))
        
    source = [[
        #pragma language glsl3
    ]]..NL..noise..NL..source
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
        io.write(self.path..'/compile.vertex', vertexShader)
        io.write(self.path..'/compile.fragment', fragmentShader)
        
        self.shader = love.graphics.newShader(fragmentShader, vertexShader)
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
    shaders.light = Shader('light')    
end
