Shader "Rus/Water Dynamic" {
   Properties {
      [Header(Colors)]
      _DiffuseColor ("Diffuse Material Color", Color) = (1,1,1,1) 
      _SpecularColor ("Specular Material Color", Color) = (1,1,1,1) 
      _Shininess ("Shininess", Float) = 10
      _PhaseSpeed("Phase Speed", Float) = 1
      _BufferSize("Buffer size", Float) = 1
   }
   SubShader {
      Pass {	
         Tags { "RenderType" = "Opaque" }
         // "LightMode" = "UniversalForward" } 

         HLSLPROGRAM
         static const float PI = 3.14159265f;
         #define FREQ(val) val * PI
         #pragma vertex vert  
         #pragma fragment frag 
 
         #include "UnityCG.cginc"
         uniform float4 _LightColor0;
         uniform float4 _DiffuseColor; 
         uniform float4 _SpecularColor; 
         uniform float _Shininess;
         float _DirX;
         float _DirZ;
         float _PhaseSpeed;

         float _BufferSize;
         float _Omegas[10];
         float _Amplitudes[10];
         float2 _Directions[10];

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
            float4 worldPos = mul(unity_ObjectToWorld, input.vertex);            
            for(int iter = 0; iter < _BufferSize; iter++)
            {
               worldPos.y += _Amplitudes[iter] * exp(sin((-_Directions[iter].x * worldPos.x + -_Directions[iter].y * worldPos.z) * FREQ(_Omegas[iter]) + _Time * _PhaseSpeed));
            }
            output.worldPos = worldPos;
            output.clipPos = UnityWorldToClipPos(worldPos);
            output.normalDir = normalize(mul(float4(input.normal, 0.0), unity_WorldToObject).xyz);
            return output;
         }
 
         float4 frag(v2f i) : SV_Target
         {
            float3 worldPos = i.worldPos;
            float total_dx = 0;
            float total_dz = 0;
            for(int iter = 0; iter < _BufferSize; iter++)
            {
                  float waveArg1 = -(_Directions[iter].x * worldPos.x + _Directions[iter].y * worldPos.z) * FREQ(_Omegas[iter]) + _Time * _PhaseSpeed;
                  float wave_1_dir = _Amplitudes[iter] * exp(sin(waveArg1)) * cos(waveArg1) * FREQ(_Omegas[iter]);
                  total_dx += -_Directions[iter].x * wave_1_dir;
                  total_dz += -_Directions[iter].y * wave_1_dir;
            }
            float3 normalDirection = normalize(float3(total_dx, 1, total_dz));
            float3 viewDirection = normalize(_WorldSpaceCameraPos - i.worldPos.xyz);
            float3 vert2LightSource = _WorldSpaceLightPos0.xyz - i.worldPos.xyz;
            // .w is 1 for Spot Light, 0 for GlobalLight
            float attenuation = lerp(1.0, 1.0 / length(vert2LightSource), _WorldSpaceLightPos0.w); //Optimization for spot lights. This isn't needed if you're just getting started.
            float3 lightDirection = _WorldSpaceLightPos0.xyz - i.worldPos.xyz * _WorldSpaceLightPos0.w;
            
            float3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb * _DiffuseColor.rgb; //Ambient component
            float3 diffuse = attenuation * _LightColor0.rgb * _DiffuseColor.rgb * max(0.0, dot(normalDirection, lightDirection)); //Diffuse component
            float3 specular = attenuation * _LightColor0.rgb * _SpecularColor.rgb
                                 * pow(max(0.0, dot(reflect(-lightDirection, normalDirection), viewDirection)), _Shininess)
                                 * sign(dot(normalDirection, lightDirection));
            float3 color = (ambient + diffuse) + specular; //Texture is not applient on specularReflection
            return float4(color, 1.0);
         }
         ENDHLSL
      }

   }
   Fallback "Specular"
}