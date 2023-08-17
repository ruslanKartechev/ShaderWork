Shader "Rus/Water ver 1" {
   Properties {
      [Header(Colors)]
      _DiffuseColor ("Diffuse Material Color", Color) = (1,1,1,1) 
      _SpecularColor ("Specular Material Color", Color) = (1,1,1,1) 
      _Shininess ("Shininess", Float) = 10
      _phase("Phase Speed", Float) = 1
      [Header(Directions)]
      _DirX("Move Dir X", Float) = 1
      _DirZ("Move Dir Z", Float) = 1
      [Header(Frequencies)]
      _omega1("_Freqw1", Float) = 1
      _omega2("_Freqw2", Float) = 1
      _omega3("_Freqw3", Float) = 1
      _omega4("_Freqw4", Float) = 1
      _omega5("_Freqw5", Float) = 1
      _omega6("_Freqw6", Float) = 1
      _omega7("_Freqw7", Float) = 1
      _omega8("_Freqw8", Float) = 1
      _omega9("_Freqw9", Float) = 1
      _omega10("_Freqw10", Float) = 1
      
      [Header(Amplitudes)]
      _Amplitude1("MaxAmplitude 1", Float) = 1
      _Amplitude2("MaxAmplitude 2", Float) = 1
      _Amplitude3("MaxAmplitude 3", Float) = 1
      _Amplitude4("MaxAmplitude 4", Float) = 1
      _Amplitude5("MaxAmplitude 5", Float) = 1
      _Amplitude6("MaxAmplitude 6", Float) = 1
      _Amplitude7("MaxAmplitude 7", Float) = 1
      _Amplitude8("MaxAmplitude 8", Float) = 1
      _Amplitude9("MaxAmplitude 9", Float) = 1
      _Amplitude10("MaxAmplitude 10", Float) = 1
      
      [Header(Directions)]
      _Dir1("Wave Dir 1", Vector) = (1,1,0,0)
      _Dir2("Wave Dir 2", Vector) = (1,1,0,0)
      _Dir3("Wave Dir 3", Vector) = (1,1,0,0)
      _Dir4("Wave Dir 4", Vector) = (1,1,0,0)
      _Dir5("Wave Dir 5", Vector) = (1,1,0,0)
      _Dir6("Wave Dir 6", Vector) = (1,1,0,0)
      _Dir7("Wave Dir 7", Vector) = (1,1,0,0)
      _Dir8("Wave Dir 8", Vector) = (1,1,0,0)
      _Dir9("Wave Dir 9", Vector) = (1,1,0,0)
      _Dir10("Wave Dir 10", Vector) = (1,1,0,0)
       
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
         float _phase;
         float _omega1;
         float _omega2;
         float _omega3;
         float _omega4;
         float _omega5;
         float _omega6;
         float _omega7;
         float _omega8;
         float _omega9;
         float _omega10;
         
         float _Amplitude1;
         float _Amplitude2;
         float _Amplitude3;
         float _Amplitude4;
         float _Amplitude5;
         float _Amplitude6;
         float _Amplitude7;
         float _Amplitude8;
         float _Amplitude9;
         float _Amplitude10;
         
         float4 _Dir1;
         float4 _Dir2;
         float4 _Dir3;
         float4 _Dir4;
         float4 _Dir5;
         float4 _Dir6;
         float4 _Dir7;
         float4 _Dir8;
         float4 _Dir9;
         float4 _Dir10;
         
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
            // testing with 1 wave only so far
            _Dir1 = normalize(_Dir1);
            _Dir2 = normalize(_Dir2);
            _Dir3 = normalize(_Dir4);
            _Dir3 = normalize(_Dir3);
            _Dir4 = normalize(_Dir4);
            _Dir5 = normalize(_Dir5);
            _Dir6 = normalize(_Dir6);
            _Dir7 = normalize(_Dir6);
            _Dir8 = normalize(_Dir6);
            _Dir9 = normalize(_Dir6);
            
            worldPos.y = worldPos.y + _Amplitude1 * sin((-_Dir1.x * worldPos.x + -_Dir1.y * worldPos.z) * FREQ(_omega1) + _Time * _phase)
                         + _Amplitude2 * sin((-_Dir2.x * worldPos.x + -_Dir2.y * worldPos.z) * FREQ(_omega2) + _Time * _phase)
                         + _Amplitude3 * sin((-_Dir3.x * worldPos.x + -_Dir3.y * worldPos.z) * FREQ(_omega3) + _Time * _phase)
                         + _Amplitude4 * sin((-_Dir4.x * worldPos.x + -_Dir4.y * worldPos.z) * FREQ(_omega4) + _Time * _phase)
                         + _Amplitude5 * sin((-_Dir5.x * worldPos.x + -_Dir5.y * worldPos.z) * FREQ(_omega5) + _Time * _phase)
                         + _Amplitude6 * sin((-_Dir6.x * worldPos.x + -_Dir6.y * worldPos.z) * FREQ(_omega6) + _Time * _phase)
                         + _Amplitude7 * sin((-_Dir7.x * worldPos.x + -_Dir7.y * worldPos.z) * FREQ(_omega7) + _Time * _phase)
                         + _Amplitude8 * sin((-_Dir8.x * worldPos.x + -_Dir8.y * worldPos.z) * FREQ(_omega8) + _Time * _phase)
                         + _Amplitude9 * sin((-_Dir9.x * worldPos.x + -_Dir9.y * worldPos.z) * FREQ(_omega9) + _Time * _phase)
                         + _Amplitude10 * sin((-_Dir10.x * worldPos.x + -_Dir10.y * worldPos.z) * FREQ(_omega10) + _Time * _phase);
            
            output.worldPos = worldPos;
            output.clipPos = UnityWorldToClipPos(worldPos);
            output.normalDir = normalize(mul(float4(input.normal, 0.0), unity_WorldToObject).xyz);
            return output;
         }
 
         float4 frag(v2f input) : SV_Target
         {
            _Dir1 = normalize(_Dir1);
            _Dir2 = normalize(_Dir2);
            _Dir3 = normalize(_Dir4);
            _Dir3 = normalize(_Dir3);
            _Dir4 = normalize(_Dir4);
            _Dir5 = normalize(_Dir5);
            _Dir6 = normalize(_Dir6);
            // wave1
            float wave_1_cos = cos((-_Dir1.x * input.worldPos.x + -_Dir1.y * input.worldPos.z) * FREQ(_omega1) + _Time * _phase);
            float wave_1_dx = -_Amplitude1 * FREQ(_omega1) * _Dir1.x * wave_1_cos;
            float wave_1_dz = -_Amplitude1 * FREQ(_omega1) * _Dir1.y * wave_1_cos;
            // wave2
            float wave_2_cos = cos((-_Dir2.x * input.worldPos.x + -_Dir2.y * input.worldPos.z) * FREQ(_omega2) + _Time * _phase);
            float wave_2_dx = -_Amplitude2 * FREQ(_omega2) * _Dir2.x * wave_2_cos;
            float wave_2_dz = -_Amplitude2 * FREQ(_omega2) * _Dir2.y * wave_2_cos;
            // wave3
            float wave_3_cos = cos((-_Dir3.x * input.worldPos.x + -_Dir3.y * input.worldPos.z) * FREQ(_omega3) + _Time * _phase);
            float wave_3_dx = -_Amplitude3 * FREQ(_omega3) * _Dir3.x * wave_3_cos;
            float wave_3_dz = -_Amplitude3 * FREQ(_omega3) * _Dir3.y * wave_3_cos;
            // wave4
            float wave_4_cos = cos((-_Dir4.x * input.worldPos.x + -_Dir4.y * input.worldPos.z) * FREQ(_omega4) + _Time * _phase);
            float wave_4_dx = -_Amplitude4 * FREQ(_omega4) * _Dir4.x * wave_4_cos;
            float wave_4_dz = -_Amplitude4 * FREQ(_omega4) * _Dir4.y * wave_4_cos;
            // wave5
            float wave_5_cos = cos((-_Dir5.x * input.worldPos.x + -_Dir5.y * input.worldPos.z) * FREQ(_omega5) + _Time * _phase);
            float wave_5_dx = -_Amplitude5 * FREQ(_omega5) * _Dir5.x * wave_5_cos;
            float wave_5_dz = -_Amplitude5 * FREQ(_omega5) * _Dir5.y * wave_5_cos;
            // wave6
            float wave_6_cos = cos((-_Dir6.x * input.worldPos.x + -_Dir6.y * input.worldPos.z) * FREQ(_omega6) + _Time * _phase);
            float wave_6_dx = -_Amplitude6 * FREQ(_omega6) * _Dir6.x * wave_6_cos;
            float wave_6_dz = -_Amplitude6 * FREQ(_omega6) * _Dir6.y * wave_6_cos;
            // wave6
            float wave_7_cos = cos((-_Dir7.x * input.worldPos.x + -_Dir7.y * input.worldPos.z) * FREQ(_omega7) + _Time * _phase);
            float wave_7_dx = -_Amplitude7 * FREQ(_omega7) * _Dir7.x * wave_7_cos;
            float wave_7_dz = -_Amplitude7 * FREQ(_omega7) * _Dir7.y * wave_7_cos;
            // wave6
            float wave_8_cos = cos((-_Dir8.x * input.worldPos.x + -_Dir8.y * input.worldPos.z) * FREQ(_omega8) + _Time * _phase);
            float wave_8_dx = -_Amplitude8 * FREQ(_omega8) * _Dir8.x * wave_8_cos;
            float wave_8_dz = -_Amplitude8 * FREQ(_omega8) * _Dir8.y * wave_8_cos;
            // wave6
            float wave_9_cos = cos((-_Dir9.x * input.worldPos.x + -_Dir9.y * input.worldPos.z) * FREQ(_omega9) + _Time * _phase);
            float wave_9_dx = -_Amplitude9 * FREQ(_omega9) * _Dir9.x * wave_9_cos;
            float wave_9_dz = -_Amplitude9 * FREQ(_omega9) * _Dir9.y * wave_9_cos;
            
            float total_dx = wave_1_dx + wave_2_dx + wave_3_dx + wave_4_dx + wave_5_dx + wave_6_dx + wave_7_dx + wave_8_dx + wave_9_dx;
            float total_dz = wave_1_dz + wave_2_dz + wave_3_dz + wave_4_dz + wave_5_dz + wave_6_dz + wave_7_dz + wave_8_dz + wave_9_dz;
            float3 normalDirection = normalize(float3(total_dx, 1, total_dz));

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
         ENDHLSL
      }

   }
   Fallback "Specular"
}