Shader "Rus/Vertical Static Fog Noise URP"
{
      Properties
    {
        _Color("Main Color", Color) = (1, 1, 1, .5) 
        _ColorUp("Color On Intersection", Color) = (1, 1, 1, .5)
        _ColorNoiseBlend("Color blended with main color", Color) = (1, 1, 1, .5)

        _FogDepth("Fog Depth", Range(0,1)) = 0.15
        _Power("Diff factor power",  Range(0,2)) = 0.38
        _NoiseTexture("Noise Texture", 2D) = "" {}
        _ScrollSpeed("Scroll speed", float) = 0
        _NoiseWaveSpeed("Noise Wave Speed", float) = 50
        _WaveAmplitudeMin("Wave Amplitude Min", Range(0,1)) = 0
        _WaveAmplitudeMax("Wave Amplitude Max", Range(0,1)) = 1
        _MainColorDarkenMax("Main Color Darken Max", Range(0,1)) = 0.5
        
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
           ZWrite Off
           CGPROGRAM
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
           float4 _Color;
           float4 _ColorUp;
           float4 _ColorNoiseBlend;
           float4 _IntersectionColor;
           float _FogDepth;
           float _Power;
           float _ScrollSpeed;
           float _MainColorDarkenMax;
            
           sampler2D _NoiseTexture;
           float4 _NoiseTexture_ST;
           float _NoiseWaveSpeed;
           float _WaveAmplitudeMin;
           float _WaveAmplitudeMax;
           
           v2f vert(appdata v)
           {
                v2f o;
                o.clipPos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.screenPos = ComputeNonStereoScreenPos(o.clipPos);
                float2 uv = TRANSFORM_TEX(v.uv, _NoiseTexture);
                uv.x = (v.uv + _Time * _ScrollSpeed) % 10;
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
                float end_color_a = saturate(lerp(0, _Color.a, alpha_lerp_t) - lerp_noise_color);
                
                end_color_a = saturate(end_color_a);
                float4 color_blended = lerp(_ColorUp, _Color, alpha_lerp_t);
                float3 blend_color = lerp(color_blended.rgb, _ColorNoiseBlend, noise_color);
                float4 final_color = float4(blend_color, end_color_a);
                return final_color;
            }
            ENDCG
        }
    }
}