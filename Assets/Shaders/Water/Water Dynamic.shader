Shader "Rus/Water Dynamic" {
   Properties 
   {
      [Header(Colors)]
      _DiffuseColor ("Diffuse Material Color", Color) = (1,1,1,1) 
      _SpecularColor ("Specular Material Color", Color) = (1,1,1,1) 
      _Shininess ("Shininess", Float) = 10
//      _PhaseSpeed("Phase Speed", Float) = 1
      _BufferSize("Buffer size", int) = 1
      _YOffset("Y offset", Float) = 0
      _IntersectionDepth("Intersection Depth", Range(0,1)) = 0.15
      _IntersectionPower("Depth Difference factor power",  Range(0,2)) = 0.38
      _IntersectionMaxAddColor("Max intersection added color", Range(0,1)) = 0.5
   }
   
   SubShader {
      Pass {	
      Tags 
        { 
            "Queue" = "Transparent" 
            "RenderType"="Transparent"
        }

         HLSLPROGRAM
         #include "UnityCG.cginc"
         #define FREQ(val) val * PI
         #pragma vertex vert  
         #pragma fragment frag 
         static const float PI = 3.14159265f;
 
         sampler2D _CameraDepthTexture;
         uniform float4 _LightColor0;
         uniform float4 _DiffuseColor; 
         uniform float4 _SpecularColor; 
         uniform float _Shininess;
         float _DirX;
         float _DirZ;
         float _PhaseSpeed;
         float _YOffset;
         float _IntersectionDepth;
         float _IntersectionPower;
         float _IntersectionMaxAddColor;
         
         int _BufferSize;
         float _Speeds[20];
         float _Omegas[20];
         float _Amplitudes[20];
         float2 _Directions[20];

         struct appdata {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
         };
         struct v2f {
            float4 clipPos : SV_POSITION;
            float4 worldPos : TEXCOORD0;
            float3 normalDir : TEXCOORD1;
            float4 screenPos : TEXCOORD2;
         };
 
         v2f vert(appdata input) 
         {
            v2f output;
            float4 worldPos = mul(unity_ObjectToWorld, input.vertex);
            for(int iter = 0; iter < _BufferSize; iter++)
            {
               worldPos.y += _Amplitudes[iter] * exp(sin((-_Directions[iter].x * worldPos.x + -_Directions[iter].y * worldPos.z) * FREQ(_Omegas[iter]) + _Time * _Speeds[iter]));
            }
            worldPos.y += _YOffset;
            output.worldPos = worldPos;
            output.clipPos = UnityWorldToClipPos(worldPos);
            output.normalDir = normalize(mul(float4(input.normal, 0.0), unity_WorldToObject).xyz);
            output.screenPos = ComputeNonStereoScreenPos(output.clipPos);
            return output;
         }
 
         float4 frag(v2f i) : SV_Target
         {
            float3 worldPos = i.worldPos;
            float total_dx = 0;
            float total_dz = 0;
            for(int iter = 0; iter < _BufferSize; iter++)
            {
                  float wave_arg = -(_Directions[iter].x * worldPos.x + _Directions[iter].y * worldPos.z) * FREQ(_Omegas[iter]) + _Time * _Speeds[iter];
                  float wave_1_dir = _Amplitudes[iter] * exp(sin(wave_arg)) * cos(wave_arg) * FREQ(_Omegas[iter]);
                  total_dx += -_Directions[iter].x * wave_1_dir;
                  total_dz += -_Directions[iter].y * wave_1_dir;
            }
            float3 normal_dir = normalize(float3(-total_dx, 1, -total_dz));
            float3 vir_dir = normalize(_WorldSpaceCameraPos - i.worldPos.xyz);
            float depth = LinearEyeDepth(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)) );
            // The difference  (depth - i.screenPos.w) is 1 where there is nothing, 0 where there is an opaque object
            float depth_diff = saturate(_IntersectionDepth * (depth - i.screenPos.w));
            float alpha_lerp_t = pow(depth_diff, _IntersectionPower);
            float light_factor = lerp(_IntersectionMaxAddColor, 0, alpha_lerp_t);
            // float lerp_noise_color = lerp(noise_color_factor, 0, depth - i.screenPos.w);
            // float color_a = saturate(lerp(0, _MainColor.a, alpha_lerp_t) - lerp_noise_color - _AlphaSubMax);
            
            float attenuation = 1;
            float3 light_direction = _WorldSpaceLightPos0.xyz;
            float3 ambient = float3(unity_SHAr.w, unity_SHAg.w, unity_SHAb.w) * _DiffuseColor; //Ambient component
            float3 diffuse = attenuation * _LightColor0.rgb * _DiffuseColor.rgb * max(0.0, dot(normal_dir, light_direction)); //Diffuse component
            float3 specular = attenuation * _LightColor0.rgb * _SpecularColor.rgb
                                 * pow(max(0.0, dot(reflect(-light_direction, normal_dir), vir_dir)), _Shininess)
                                 * sign(dot(normal_dir, light_direction));
            float3 color = (ambient + diffuse) + specular; //Texture is not applient on specularReflection
            color += light_factor;
            return float4(saturate(color), 1.0);
         }
         ENDHLSL
      }

   }
   Fallback "Specular"
}