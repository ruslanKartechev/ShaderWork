Shader "Rus/Vertical Static Fog Noise URP"
{
      Properties
    {
        _MainColor("Main Color", Color) = (1, 1, 1, .5) 
        _ColorUp("Color On Intersection", Color) = (1, 1, 1, .5)
        _ColorNoiseBlend("Color blended with main color", Color) = (1, 1, 1, .5)

        _FogDepth("Fog Depth", Range(0,1)) = 0.15
        _Power("Diff factor power",  Range(0,2)) = 0.38
        _NoiseTexture("Noise Texture", 2D) = "" {}
        _ScrollSpeed("Scroll speed", float) = 0
        _ColorNoiseBlendFactor("Color Noise Blend Factor", Range(0,1)) = 0.5

    }
    SubShader
    {
        Tags 
        { 
            "Queue" = "Transparent" 
            "RenderType"="Transparent"
        }
        
        Pass
        {
           Blend SrcAlpha OneMinusSrcAlpha
           HLSLPROGRAM
           #pragma vertex vert
           #pragma fragment frag
           #include "UnityCG.cginc"
  
           struct appdata
           {
               float4 vertex : POSITION;
               float2 uv : TEXCOORD0;
           };
  
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
                float4 screenPos : TEXCOORD2;
                float4 clipPos : SV_POSITION;
            };

           sampler2D _CameraDepthTexture;
           float4 _MainColor;
           float4 _ColorUp;
           float4 _ColorNoiseBlend;
           float4 _IntersectionColor;
           float _ColorNoiseBlendFactor;
           float _FogDepth;
           float _Power;
           float _ScrollSpeed;
            
           sampler2D _NoiseTexture;
           float4 _NoiseTexture_ST;
           
           v2f vert(appdata input)
           {
                v2f o;
                o.clipPos = UnityObjectToClipPos(input.vertex);
                o.worldPos = mul(unity_ObjectToWorld, input.vertex);
                o.screenPos = ComputeNonStereoScreenPos(o.clipPos);
                float2 uv = TRANSFORM_TEX(input.uv, _NoiseTexture);
                uv.x = (input.uv + _Time * _ScrollSpeed) % 10;
                o.uv = uv;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;   
           }

           inline float Remap(float input, float from1, float to1, float from2, float to2)
           {
                return (input - from1) / (to1 - from1) * (to2 - from2) + from2;
           }   
  
           float4 frag(v2f i) : SV_TARGET
            {
                float noise_color = saturate(tex2D(_NoiseTexture, float2(i.uv.x, i.uv.y)).x );
                float depth = LinearEyeDepth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)));
                // The difference  (depth - i.screenPos.w) is 1 where there is nothing, 0 where there is an opaque object
                float depth_diff = saturate(_FogDepth * (depth - i.screenPos.w));
                float alpha_lerp_t = pow(depth_diff, _Power);
                float lerp_noise_color = lerp(noise_color, 0, depth - i.screenPos.w);
                float end_color_a = saturate(lerp(0, _MainColor.a, alpha_lerp_t) - lerp_noise_color);
                
                float4 vertical_blend_color = lerp(_ColorUp, _MainColor, alpha_lerp_t);
                float3 blend_color = lerp(vertical_blend_color.rgb, _ColorNoiseBlend, noise_color * _ColorNoiseBlendFactor);
                float4 final_color = float4(blend_color, end_color_a);
                return final_color;
            }
            ENDHLSL
        }
    }
}