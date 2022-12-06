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
        io.read(self.path..'/'..'_noise2D.glsl')..
        io.read(self.path..'/'..'_noise3D.glsl')
    )

    source = (
        includes..NL..
        '#line 0'..NL..
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

    local version = [[#pragma language glsl3
precision highp float;
precision highp int;
//#define lowp
#define mediump highp
//#define highp
#define DEF mediump

]]
    
    if vertexShader then
        vertexShader = version..self:complete(GL_VERTEX_SHADER, vertexShader)
    end

    if fragmentShader then
        fragmentShader = version..self:complete(GL_FRAGMENT_SHADER, fragmentShader)
    end

    if vertexShader or fragmentShader then        
        io.write('_shader.vertex', vertexShader)
        io.write('_shader.fragment', fragmentShader)
        
        self.program = love.graphics.newShader(fragmentShader, vertexShader)
    end
end

class 'Shaders' : extends(table)

function Shaders.setup()
    shaders = Shaders()

    shaders.default = Shader('default')
    shaders.terrain = Shader('terrain2d')
end
