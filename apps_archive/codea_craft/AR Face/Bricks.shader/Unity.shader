// Created with Shade for iPad
Shader "Shade/Bricks"
{
    Properties
    {
        _BrickCount  ("Brick Count", Vector) = (5.0, 10.0, 0, 0)
        [NoScaleOffset] _Texture  ("Texture", 2D) = "white" {}
        [NoScaleOffset] _BrickGradient  ("Brick Gradient", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "Queue"="Geometry" "RenderType"="Opaque" }
        ZWrite On
        LOD 200

        CGPROGRAM
        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard vertex:vert finalcolor:customColor fullforwardshadows addshadow
        struct Input {
            float2 texcoord : TEXCOORD0;
        };

        float2 _BrickCount;

        sampler2D _Texture;

        sampler2D _BrickGradient;
        
        // Source - https://stackoverflow.com/questions/5281261/generating-a-normal-map-from-a-height-map
        
        float sampleHeightN(float2 uv)
        {
            return smoothstep(0.8, 0.9, (1.0 - (length(max((abs((frac(((uv * _BrickCount) + float2((step(1.0, fmod((uv * _BrickCount).y, 2.0)) * 0.5), 0.0))) - 0.5)) - (0.3 - 0.0)), float2(0.0, 0.0)))-0.0)));
        }
        
        float3 heightToNormal(float2 uv, float strength, float2 texelSize, float2 offset)
        {
            const float2 size = float2(2.0,0.0);
            const float3 off = float3(-1.0,0.0,1.0);
        
            float2 delta = texelSize;
        
            float s11 = sampleHeightN(uv + offset);
            float s01 = sampleHeightN(uv + delta * off.xy + offset);
            float s21 = sampleHeightN(uv + delta * off.zy + offset);
            float s10 = sampleHeightN(uv + delta * off.yx + offset);
            float s12 = sampleHeightN(uv + delta * off.yz + offset);
        
            float3 va = normalize(float3(size.x, size.y, (s21-s01) * strength));
            float3 vb = normalize(float3(size.y, size.x, (s12-s10) * strength));
        
            return cross(va,vb);
        }
        
        
        // Source - http://blog.selfshadow.com/publications/blending-in-detail/
        
        float3 blendNormals(float3 n1, float3 n2)
        {
            float3x3 nBasis = float3x3(
                float3(n1.z, n1.y, -n1.x), // +90 degree rotation around y axis
                float3(n1.x, n1.z, -n1.y), // -90 degree rotation around x axis
                float3(n1.x, n1.y,  n1.z));
        
            return normalize(n2.x*nBasis[0] + n2.y*nBasis[1] + n2.z*nBasis[2]);
        }
        
        

        #include "UnityPBSLighting.cginc"
        void customColor (Input IN, SurfaceOutputStandard o, inout fixed4 color)
        {
        #ifndef UNITY_PASS_FORWARDADD
        color = fixed4(lerp(float3(0.0, 0.0, 0.0), color.rgb, o.Alpha), 1.0);
        #endif
        }

        void vert (inout appdata_full v, out Input o)
        {
            UNITY_INITIALIZE_OUTPUT(Input, o);
            o.texcoord = v.texcoord;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float mod_15_1 = fmod((IN.texcoord * _BrickCount).y, 2.0);
            float step_14_1 = step(1.0, mod_15_1);
            float multiply_17_1 = (step_14_1 * 0.5);
            float2 add_13_1 = ((IN.texcoord * _BrickCount) + float2(multiply_17_1, 0.0));
            float2 fract_18_1 = frac(add_13_1);
            float2 subtract_3_1 = (fract_18_1 - 0.5);
            float2 abs_4_1 = abs(subtract_3_1);
            float subtract_11_1 = (0.3 - 0.0);
            float2 subtract_5_1 = (abs_4_1 - subtract_11_1);
            float2 max_6_1 = max(subtract_5_1, float2(0.0, 0.0));
            float length_7_1 = length(max_6_1);
            float oneminus_8_1 = (1.0 - (length_7_1-0.0));
            float smoothstep_12_1 = smoothstep(0.8, 0.9, oneminus_8_1);
            float4 temp_Texture = ((tex2D(_Texture, (IN.texcoord*float2(2.0, 2.0))) * 2.0 - 1.0) * float4((0.5*smoothstep_12_1), (0.5*smoothstep_12_1), 1.0, 1.0));
            float3 temp_20 = heightToNormal(IN.texcoord, 1.9829, float2(0.01, 0.01), float2(0.0, 0.0));
            float3 blendNormals_23_1 = blendNormals(temp_Texture.rgb, temp_20);
            o.Normal = blendNormals_23_1;
            o.Emission = float3(0.0, 0.0, 0.0);
            float4 temp_BrickGradient = tex2D(_BrickGradient, float2(smoothstep(0.8, 0.9, (1.0 - (length(max((abs((frac(((IN.texcoord * _BrickCount) + float2((step(1.0, fmod((IN.texcoord * _BrickCount).y, 2.0)) * 0.5), 0.0))) - 0.5)) - (0.3 - 0.0)), float2(0.0, 0.0)))-0.0))), 0.0));
            o.Albedo = temp_BrickGradient.rgb;
            o.Smoothness = (1.0 - 0.51645);
            o.Metallic = 0.0;
            o.Alpha = 1.1039;
            o.Occlusion = 1.0;
        }
        ENDCG
    }
}
