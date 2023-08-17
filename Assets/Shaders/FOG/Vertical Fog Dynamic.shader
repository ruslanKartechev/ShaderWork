Shader "Rus/Vertical Dynamic Fog"
{
    Properties
    {
        _Color("Main Color", Color) = (1, 1, 1, .5)
        _ColorUp("Color on top", Color) = (1, 1, 1, .5)
        _DepthDifferenceFactor("Depth Difference Factor", Float) = 0.15
        _Power("Diff factor power", Float) = 0.38
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" 
            "RenderType"="Transparent"  }
        
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
           };
  
            struct v2f
            {
                float4 clipPos : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
  
           sampler2D _CameraDepthTexture;
           float4 _Color;
           float4 _ColorUp;
           float4 _IntersectionColor;
           float _DepthDifferenceFactor;
           float _Power;
           
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.clipPos = ComputeScreenPos(o.vertex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;   
            }
  
            half4 frag(v2f i) : SV_TARGET
            {
                float depth = LinearEyeDepth (tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.clipPos)));
                float diff = saturate(_DepthDifferenceFactor * (depth - i.clipPos.w));
                float lerpT = pow(diff, _Power);
                float finalAlpha = lerp(0.0, _Color.a, lerpT);
                float4 colorBlended = lerp(_ColorUp, _Color, lerpT);
                fixed4 finalColor = fixed4(colorBlended.rgb, finalAlpha);                
                return finalColor;
            }
  
            ENDCG
        }
    }
}