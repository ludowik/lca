require 'engine.core'
require 'engine'

require 'libc.library'
require 'libc.sdl.sdl'
require 'libc.opengl.opengl'
require 'libc.openal.openal'
require 'libc.freetype.freetype'

renderer = OpenGL()

sdl = Sdl()
sdl:initialize()
-- renderer:initialize()

al = OpenAL()
al:initialize()


FreeType.setup()

ft = FreeType()
ft:initialize()
