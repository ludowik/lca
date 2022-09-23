    {
        name = "Bricks",

        options =
        {
            USE_COLOR = { true },
            USE_LIGHTING = { true },
            STANDARD = { true },
            PHYSICAL = { true },
            ENVMAP_TYPE_CUBE = { true },
            ENVMAP_MODE_REFLECTION = { true },
            USE_ENVMAP = { false, {"envMap"} },
            SELECTION_MODE = { true },
        },

        properties =
        {
            envMap = { "cubeTexture", "nil" },
            envMapIntensity = { "float", "0.75" },
            refactionRatio = { "float", "0.5" },
            _brickCount = { "vec2", {5.0, 10.0} },
            _texture = { "texture2D", "T_NoiseNormal_39" },
            _brickGradient = { "texture2D", "Brick Gradient" },
        },

        pass =
        {
            base = "Surface",

            blendMode = "disabled",
            depthWrite = true,
            depthFunc = "lessEqual",
            renderQueue = "solid",
            colorMask = {"rgba"},
            cullFace = "back",


            vertex =
            [[


                void vertex(inout Vertex v, out Input o)
                {
                }
            ]],

            surface =
            [[
                uniform vec2 _brickCount;
                uniform lowp sampler2D _texture;
                uniform lowp sampler2D _brickGradient;


                
                // Source - https://stackoverflow.com/questions/5281261/generating-a-normal-map-from-a-height-map
                
                float sampleHeightN(vec2 uv)
                {
                    return smoothstep(0.8, 0.9, (1.0 - (length(max((abs((fract(((uv * _brickCount) + vec2((step(1.0, mod((uv * _brickCount).y, 2.0)) * 0.5), 0.0))) - 0.5)) - (0.3 - 0.0)), vec2(0.0, 0.0)))-0.0)));
                }
                
                vec3 heightToNormal(vec2 uv, float strength, vec2 texelSize, vec2 offset)
                {
                    const vec2 size = vec2(2.0,0.0);
                    const vec3 off = vec3(-1.0,0.0,1.0);
                
                    vec2 delta = texelSize;
                
                    float s11 = sampleHeightN(uv + offset);
                    float s01 = sampleHeightN(uv + delta * off.xy + offset);
                    float s21 = sampleHeightN(uv + delta * off.zy + offset);
                    float s10 = sampleHeightN(uv + delta * off.yx + offset);
                    float s12 = sampleHeightN(uv + delta * off.yz + offset);
                
                    vec3 va = normalize(vec3(size.x, size.y, (s21-s01) * strength));
                    vec3 vb = normalize(vec3(size.y, size.x, (s12-s10) * strength));
                
                    return cross(va,vb);
                }
                
                
                // Source - http://blog.selfshadow.com/publications/blending-in-detail/
                
                vec3 blendNormals(vec3 n1, vec3 n2)
                {
                    mat3 nBasis = mat3(
                        vec3(n1.z, n1.y, -n1.x), // +90 degree rotation around y axis
                        vec3(n1.x, n1.z, -n1.y), // -90 degree rotation around x axis
                        vec3(n1.x, n1.y,  n1.z));
                
                    return normalize(n2.x*nBasis[0] + n2.y*nBasis[1] + n2.z*nBasis[2]);
                }
                
                

                void surface(in Input IN, inout SurfaceOutput o)
                {
                    float mod_15_1 = mod((IN.uv * _brickCount).y, 2.0);
                    float step_14_1 = step(1.0, mod_15_1);
                    float multiply_17_1 = (step_14_1 * 0.5);
                    vec2 add_13_1 = ((IN.uv * _brickCount) + vec2(multiply_17_1, 0.0));
                    vec2 fract_18_1 = fract(add_13_1);
                    vec2 subtract_3_1 = (fract_18_1 - 0.5);
                    vec2 abs_4_1 = abs(subtract_3_1);
                    float subtract_11_1 = (0.3 - 0.0);
                    vec2 subtract_5_1 = (abs_4_1 - subtract_11_1);
                    vec2 max_6_1 = max(subtract_5_1, vec2(0.0, 0.0));
                    float length_7_1 = length(max_6_1);
                    float oneminus_8_1 = (1.0 - (length_7_1-0.0));
                    float smoothstep_12_1 = smoothstep(0.8, 0.9, oneminus_8_1);
                    vec4 temp_Texture = ((texture(_texture, (IN.uv*vec2(2.0, 2.0))) * 2.0 - 1.0) * vec4((0.5*smoothstep_12_1), (0.5*smoothstep_12_1), 1.0, 1.0));
                    vec3 temp_20 = heightToNormal(IN.uv, 1.9829, vec2(0.01, 0.01), vec2(0.0, 0.0));
                    vec3 blendNormals_23_1 = blendNormals(temp_Texture.rgb, temp_20);
                    o.normal = perturbNormal2Arb( -IN.viewPosition, IN.normal, blendNormals_23_1);
                    o.emissive = 1.0;
                    vec4 temp_BrickGradient = texture(_brickGradient, vec2(smoothstep(0.8, 0.9, (1.0 - (length(max((abs((fract(((IN.uv * _brickCount) + vec2((step(1.0, mod((IN.uv * _brickCount).y, 2.0)) * 0.5), 0.0))) - 0.5)) - (0.3 - 0.0)), vec2(0.0, 0.0)))-0.0))), 0.0));
                    o.diffuse = temp_BrickGradient.rgb;
                    o.roughness = 0.51645;
                    o.metalness = 0.0;
                    o.emission = vec3(0.0, 0.0, 0.0);
                    o.opacity = 1.1039;
                    o.occlusion = 1.0;
                }
            ]]
        }
    }
    