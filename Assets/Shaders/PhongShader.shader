Shader "Rus/Phong" {
   Properties {
      _DiffuseColor ("Diffuse Material Color", Color) = (1,1,1,1) 
      _SpecularColor ("Specular Material Color", Color) = (1,1,1,1) 
      _Shininess ("Shininess", Float) = 10
   }
   SubShader {
      Pass {	
         Tags { "RenderType" = "Opaque" }
         // "LightMode" = "UniversalForward" } 
 
         CGPROGRAM
 
         #pragma vertex vert  
         #pragma fragment frag 
 
         #include "UnityCG.cginc"
         uniform float4 _LightColor0; // color of light source (from "Lighting.cginc")
 
         // User-specified properties
         uniform float4 _DiffuseColor; 
         uniform float4 _SpecularColor; 
         uniform float _Shininess;
 
         struct appdata {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
         };
         struct v2f {
            float4 clipPos : SV_POSITION;
            float4 worldPos : TEXCOORD0;
            float3 normalDir : TEXCOORD1;
         };
 
         v2f vert(appdata input) 
         {
            v2f output;
            output.worldPos = mul(unity_ObjectToWorld, input.vertex);
            output.normalDir = normalize(mul(float4(input.normal, 0.0), unity_WorldToObject).xyz);
            output.clipPos = UnityObjectToClipPos(input.vertex);
            return output;
         }
 
         float4 frag(v2f input) : SV_Target
         {
            float3 normalDirection = normalize(input.normalDir);
            float3 viewDirection = normalize(_WorldSpaceCameraPos - input.worldPos.xyz);
            float3 vert2LightSource = _WorldSpaceLightPos0.xyz - input.worldPos.xyz;
            // .w is 1 for Spot Light, 0 for GlobalLight
            float attenuation = lerp(1.0, 1.0 / length(vert2LightSource), _WorldSpaceLightPos0.w); //Optimization for spot lights. This isn't needed if you're just getting started.
            float3 lightDirection = _WorldSpaceLightPos0.xyz - input.worldPos.xyz * _WorldSpaceLightPos0.w;

            float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * _DiffuseColor.rgb; //Ambient component
            float3 diffuse = attenuation * _LightColor0.rgb * _DiffuseColor.rgb * max(0.0, dot(normalDirection, lightDirection)); //Diffuse component
            float3 specular = attenuation * _LightColor0.rgb * _SpecularColor.rgb
                                 * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess)
                                 * sign(dot(input.normalDir, lightDirection));
            float3 color = (ambient + diffuse) + specular; //Texture is not applient on specularReflection
            return float4(color, 1.0);
         }
         ENDCG
      }

   }
   Fallback "Specular"
}