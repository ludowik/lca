class('ShaderToy', Shader)

function ShaderToy.setup()
    shaderChannel = {
        [0] = Image(appPath..'/channel/cube00_0.jpg')
    }
    
end

function ShaderToy:init(name, path)
    self.shaderFilePath = path..'/'..name
    self.nameVertex = '_shadertoy'

    self.path = shadersPath

    Shader.init(self, name, shadersPath)
end

function ShaderToy:complete(shaderType, source)
    if shaderType == GL_FRAGMENT_SHADER then
        local defaultUniforms = [[
            #pragma language glsl3
            
            uniform vec3      iResolution;           // viewport resolution (in pixels)
            uniform float     iTime;                 // shader playback time (in seconds)
            uniform float     iTimeDelta;            // render time (in seconds)
            uniform int       iFrame;                // shader playback frame
            uniform int       iFrameRate;            // frame rate
            uniform float     iChannelTime[4];       // channel playback time (in seconds)
            uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
            uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
            uniform sampler2D iChannel0;             // input channel. XX = 2D/Cube
            uniform sampler2D iChannel1;             // input channel. XX = 2D/Cube
            uniform sampler2D iChannel2;             // input channel. XX = 2D/Cube
            uniform sampler2D iChannel3;             // input channel. XX = 2D/Cube
            uniform vec4      iDate;                 // (year, month, day, time in seconds)
            uniform float     iSampleRate;           // sound sample rate (i.e., 44100)

            varying vec3 vPosition;
            varying vec2 vTexCoords;

            #define PI 3.14159265359
            
            #define love_texture Texel
            
            #line 1
        ]]

        local ender = [[
            vec4 effect(vec4 frag_color, Image tex, vec2 texture_coords, vec2 screen_coords) {
                vec2 frag_coord = screen_coords; // texture_coords * iResolution.xy;
                mainImage(frag_color, frag_coord);
                return frag_color;
            }

            #if VERSION > 0
            void main() {
                gl_FragColor = effect(vec4(1.0), iChannel0, vTexCoords, vPosition.xy);
            }
            #endif
        ]]

        return defaultUniforms..source..ender
        
    else
        local defaultUniforms = [[
            #pragma language glsl3            
            #line 1
        ]]

        local ender = [[
        ]]

        return defaultUniforms..source..ender
    end

    return source
end

function loadShaders(all)
    local directoryItems = dir(shadersPath)

    for i,shaderFileName in ipairs(directoryItems) do
        local _path,_name,extension = splitFilePath(shaderFileName)
        if extension ~= 'vertex' then
            local shader = ShaderToy(_name, _path)
            if shader and shader.error == nil then
                initShader(shader)
                shaders:add(shader)
            end

            if env.thread then
                if all then
                    coroutine.yield()
                else
                    loadNext = false
                    while loadNext == false do
                        coroutine.yield()
                    end
                end
            elseif not all then
                break
            end
        end
    end
end
