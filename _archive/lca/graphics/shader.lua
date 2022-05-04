class 'Shader'

class 'Shaders' : extends(table)

function Shaders.setup()
    shaders = Shaders()
    
    shaders.default = Shader()
    shaders.terrain = Shader()
    shaders.terrain2d = Shader()
    shaders.rect = Shader()
    shaders.model3d = Shader()
end
