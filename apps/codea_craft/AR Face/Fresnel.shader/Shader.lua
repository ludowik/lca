    {
        name = "Fresnel",

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
            _power = { "float", 3.0 },
            _color = { "vec3", {0.0, 0.89335036277771, 1.0} },
            _intensity = { "float", 1.5 },
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
                uniform float _power;
                uniform vec3 _color;
                uniform float _intensity;


                

                void surface(in Input IN, inout SurfaceOutput o)
                {
                    o.emissive = 1.0;
                    o.diffuse = vec3(0.0, 0.0, 0.0);
                    o.roughness = 1.0;
                    o.metalness = 0.0;
                    float dot_4_1 = dot(normalize(IN.normal), normalize(IN.viewPosition));
                    float oneminus_5_1 = (1.0 - dot_4_1);
                    float pow_6_1 = pow(oneminus_5_1, _power);
                    vec3 multiply_8_1 = (pow_6_1 * (_color*vec3(_intensity, _intensity, _intensity)));
                    o.emission = multiply_8_1;
                    o.opacity = 1.0;
                    o.occlusion = 1.0;
                }
            ]]
        }
    }
    