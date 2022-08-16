// Created with Shade for iPad
Shader "Shade/Fresnel"
{
    Properties
    {
        _Power  ("Power", float) = 3.00
        _Color  ("Color", Color) = (0.0, 0.89335036277771, 1.0, 0)
        _Intensity  ("Intensity", float) = 1.50
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
            float3 viewDirection;
            float3 normal;
        };

        float _Power;

        float3 _Color;

        float _Intensity;
        

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
            o.normal = COMPUTE_VIEW_NORMAL;
            o.viewDirection = -UnityObjectToViewPos(v.vertex.xyz);
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float dot_4_1 = dot(normalize(IN.normal), normalize(IN.viewDirection));
            float oneminus_5_1 = (1.0 - dot_4_1);
            float pow_6_1 = pow(oneminus_5_1, _Power);
            float3 multiply_8_1 = (pow_6_1 * (_Color*float3(_Intensity, _Intensity, _Intensity)));
            o.Emission = multiply_8_1;
            o.Albedo = float3(0.0, 0.0, 0.0);
            o.Smoothness = (1.0 - 1.0);
            o.Metallic = 0.0;
            o.Alpha = 1.0;
            o.Occlusion = 1.0;
        }
        ENDCG
    }
}
