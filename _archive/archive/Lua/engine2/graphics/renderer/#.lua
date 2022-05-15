rendererMode = 'OPENGL'

require 'graphics.renderer.mediaInterface'
require 'graphics.renderer.rendererInterface'
require 'graphics.renderer.audioInterface'

if rendererMode == 'OPENGL' then
    require 'graphics.renderer.opengl.meshRender'
    require 'graphics.mesh'

--require 'graphics.renderer.shader'
    require 'graphics.renderer.opengl.shader'

    require 'graphics.image'
    require 'graphics.renderer.opengl.image'

    gl = OpenGL()
    
    renderer = gl

elseif rendererMode == 'VULKAN' then
    require 'graphics.mesh'

    require 'graphics.renderer.shader'

    require 'graphics.image'

    vulkan = Vulkan()

    renderer = vulkan

end

function Renderer()
    return renderer
end
