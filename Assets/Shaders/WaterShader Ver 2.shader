Shader "Rus/Water ver 2" {
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
      _omega1("Frequency 1", Float) = 1
      _omega2("Frequency 2", Float) = 1
      _omega3("Frequency 3", Float) = 1
      _omega4("Frequency 4", Float) = 1
      _omega5("Frequency 5", Float) = 1
      _omega6("Frequency 6", Float) = 1
      _omega7("Frequency 7", Float) = 1
      _omega8("Frequency 8", Float) = 1
      _omega9("Frequency 9", Float) = 1
      _omega10("Frequency 10", Float) = 1
      _omega11("Frequency 11", Float) = 1
      _omega12("Frequency 12", Float) = 1
      _omega13("Frequency 13", Float) = 1
      _omega14("Frequency 14", Float) = 1
      _omega15("Frequency 15", Float) = 1
      
      [Header(Amplitudes)]
      _Amplitude1("Amplitude 1", Float) = 1
      _Amplitude2("Amplitude 2", Float) = 1
      _Amplitude3("Amplitude 3", Float) = 1
      _Amplitude4("Amplitude 4", Float) = 1
      _Amplitude5("Amplitude 5", Float) = 1
      _Amplitude6("Amplitude 6", Float) = 1
      _Amplitude7("Amplitude 7", Float) = 1
      _Amplitude8("Amplitude 8", Float) = 1
      _Amplitude9("Amplitude 9", Float) = 1
      _Amplitude10("Amplitude 10", Float) = 1
      _Amplitude11("Amplitude 11", Float) = 1
      _Amplitude12("Amplitude 12", Float) = 1
      _Amplitude13("Amplitude 13", Float) = 1
      _Amplitude14("Amplitude 14", Float) = 1
      _Amplitude15("Amplitude 15", Float) = 1
      
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
      _Dir11("Wave Dir 11", Vector) = (1,1,0,0)
      _Dir12("Wave Dir 12", Vector) = (1,1,0,0)
      _Dir13("Wave Dir 13", Vector) = (1,1,0,0)
      _Dir14("Wave Dir 14", Vector) = (1,1,0,0)
      _Dir15("Wave Dir 15", Vector) = (1,1,0,0)
       
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
         float _omega11;
         float _omega12;
         float _omega13;
         float _omega14;
         float _omega15;
         
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
         float _Amplitude11;
         float _Amplitude12;
         float _Amplitude13;
         float _Amplitude14;
         float _Amplitude15;
         
         float2 _Dir1;
         float2 _Dir2;
         float2 _Dir3;
         float2 _Dir4;
         float2 _Dir5;
         float2 _Dir6;
         float2 _Dir7;
         float2 _Dir8;
         float2 _Dir9;
         float2 _Dir10;
         float2 _Dir11;
         float2 _Dir12;
         float2 _Dir13;
         float2 _Dir14;
         float2 _Dir15;
         
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
            
            worldPos.y = worldPos.y + _Amplitude1 * exp(sin((-_Dir1.x * worldPos.x + -_Dir1.y * worldPos.z) * FREQ(_omega1) + _Time * _phase))
                         + _Amplitude2 * exp(sin((-_Dir2.x * worldPos.x + -_Dir2.y * worldPos.z) * FREQ(_omega2) + _Time * _phase))
                         + _Amplitude3 * exp(sin((-_Dir3.x * worldPos.x + -_Dir3.y * worldPos.z) * FREQ(_omega3) + _Time * _phase))
                         + _Amplitude4 * exp(sin((-_Dir4.x * worldPos.x + -_Dir4.y * worldPos.z) * FREQ(_omega4) + _Time * _phase))
                         + _Amplitude5 * exp(sin((-_Dir5.x * worldPos.x + -_Dir5.y * worldPos.z) * FREQ(_omega5) + _Time * _phase))
                         + _Amplitude6 * exp(sin((-_Dir6.x * worldPos.x + -_Dir6.y * worldPos.z) * FREQ(_omega6) + _Time * _phase))
                         + _Amplitude7 * exp(sin((-_Dir7.x * worldPos.x + -_Dir7.y * worldPos.z) * FREQ(_omega7) + _Time * _phase))
                         + _Amplitude8 * exp(sin((-_Dir8.x * worldPos.x + -_Dir8.y * worldPos.z) * FREQ(_omega8) + _Time * _phase))
                         + _Amplitude9 * exp(sin((-_Dir9.x * worldPos.x + -_Dir9.y * worldPos.z) * FREQ(_omega9) + _Time * _phase))
                         + _Amplitude10 * exp(sin((-_Dir10.x * worldPos.x + -_Dir10.y * worldPos.z) * FREQ(_omega10) + _Time * _phase))
                         + _Amplitude11 * exp(sin((-_Dir11.x * worldPos.x + -_Dir11.y * worldPos.z) * FREQ(_omega11) + _Time * _phase))
                         + _Amplitude12 * exp(sin((-_Dir12.x * worldPos.x + -_Dir12.y * worldPos.z) * FREQ(_omega12) + _Time * _phase))
                         + _Amplitude13 * exp(sin((-_Dir13.x * worldPos.x + -_Dir13.y * worldPos.z) * FREQ(_omega13) + _Time * _phase))
                         + _Amplitude14 * exp(sin((-_Dir14.x * worldPos.x + -_Dir14.y * worldPos.z) * FREQ(_omega14) + _Time * _phase))
                         + _Amplitude15 * exp(sin((-_Dir15.x * worldPos.x + -_Dir15.y * worldPos.z) * FREQ(_omega15) + _Time * _phase));
            
            output.worldPos = worldPos;
            output.clipPos = UnityWorldToClipPos(worldPos);
            output.normalDir = normalize(mul(float4(input.normal, 0.0), unity_WorldToObject).xyz);
            return output;
         }
 
         float4 frag(v2f i) : SV_Target
         {
            float3 worldPos = i.worldPos;
            // wave1
            float waveArg1 = -(_Dir1.x * worldPos.x + _Dir1.y * worldPos.z) * FREQ(_omega1) + _Time * _phase;
            float wave_1_dir = _Amplitude1 * exp(sin(waveArg1)) * cos(waveArg1) * FREQ(_omega1);
            float wave_1_dx = -_Dir1.x * wave_1_dir;
            float wave_1_dz = -_Dir1.y * wave_1_dir;
            // wave2
            float waveArg2 = -(_Dir2.x * worldPos.x + _Dir2.y * worldPos.z) * FREQ(_omega2) + _Time * _phase;
            float wave_2_dir = _Amplitude2 * exp(sin(waveArg2)) * cos(waveArg2) * FREQ(_omega2);
            float wave_2_dx = -_Dir2.x * wave_2_dir;
            float wave_2_dz = -_Dir2.y * wave_2_dir;
            // wave3
            float waveArg3 = -(_Dir3.x * worldPos.x + _Dir3.y * worldPos.z) * FREQ(_omega3) + _Time * _phase;
            float wave_3_dir = _Amplitude3 * exp(sin(waveArg3)) * cos(waveArg3) * FREQ(_omega3);
            float wave_3_dx = -_Dir3.x * wave_3_dir;
            float wave_3_dz = -_Dir3.y * wave_3_dir;
            // wave4
            float waveArg4 = -(_Dir4.x * worldPos.x + _Dir4.y * worldPos.z) * FREQ(_omega4) + _Time * _phase;
            float wave_4_dir = _Amplitude4 * exp(sin(waveArg4)) * cos(waveArg4) * FREQ(_omega4);
            float wave_4_dx = -_Dir4.x * wave_4_dir;
            float wave_4_dz = -_Dir4.y * wave_4_dir;
            // wave5
             float waveArg5 = -(_Dir5.x * worldPos.x + _Dir5.y * worldPos.z) * FREQ(_omega5) + _Time * _phase;
            float wave_5_dir = _Amplitude5 * exp(sin(waveArg5)) * cos(waveArg5) * FREQ(_omega5);
            float wave_5_dx = -_Dir5.x * wave_5_dir;
            float wave_5_dz = -_Dir5.y * wave_5_dir;
            // wave6
            float waveArg6 = -(_Dir6.x * worldPos.x + _Dir6.y * worldPos.z) * FREQ(_omega6) + _Time * _phase;
            float wave_6_dir = _Amplitude6 * exp(sin(waveArg6)) * cos(waveArg6) * FREQ(_omega6);
            float wave_6_dx = -_Dir6.x * wave_6_dir;
            float wave_6_dz = -_Dir6.y * wave_6_dir;
            // wave7
            float waveArg7 = -(_Dir7.x * worldPos.x + _Dir7.y * worldPos.z) * FREQ(_omega7) + _Time * _phase;
            float wave_7_dir = _Amplitude7 * exp(sin(waveArg7)) * cos(waveArg7) * FREQ(_omega7);
            float wave_7_dx = -_Dir7.x * wave_7_dir;
            float wave_7_dz = -_Dir7.y * wave_7_dir;
            // wave8
            float waveArg8 = -(_Dir8.x * worldPos.x + _Dir8.y * worldPos.z) * FREQ(_omega8) + _Time * _phase;
            float wave_8_dir = _Amplitude8 * exp(sin(waveArg8)) * cos(waveArg8) * FREQ(_omega8);
            float wave_8_dx = -_Dir8.x * wave_8_dir;
            float wave_8_dz = -_Dir8.y * wave_8_dir;
            // wave9
            float waveArg9 = -(_Dir9.x * worldPos.x + _Dir9.y * worldPos.z) * FREQ(_omega9) + _Time * _phase;
            float wave_9_dir = _Amplitude9 * exp(sin(waveArg9)) * cos(waveArg9) * FREQ(_omega9);
            float wave_9_dx = -_Dir9.x * wave_9_dir;
            float wave_9_dz = -_Dir9.y * wave_9_dir;
            // wave 10
            float waveArg10 = -(_Dir10.x * worldPos.x + _Dir10.y * worldPos.z) * FREQ(_omega10) + _Time * _phase;
            float wave_10_dir = _Amplitude10 * exp(sin(waveArg10)) * cos(waveArg10) * FREQ(_omega10);
            float wave_10_dx = -_Dir10.x * wave_10_dir;
            float wave_10_dz = -_Dir10.y * wave_10_dir;
            // wave 11
            float waveArg11 = -(_Dir11.x * worldPos.x + _Dir11.y * worldPos.z) * FREQ(_omega11) + _Time * _phase;
            float wave_11_dir = _Amplitude11 * exp(sin(waveArg11)) * cos(waveArg11) * FREQ(_omega11);
            float wave_11_dx = -_Dir11.x * wave_11_dir;
            float wave_11_dz = -_Dir11.y * wave_11_dir;
            // wave 12
            float waveArg12 = -(_Dir12.x * worldPos.x + _Dir12.y * worldPos.z) * FREQ(_omega12) + _Time * _phase;
            float wave_12_dir = _Amplitude12 * exp(sin(waveArg12)) * cos(waveArg12) * FREQ(_omega12);
            float wave_12_dx = -_Dir12.x * wave_12_dir;
            float wave_12_dz = -_Dir12.y * wave_12_dir;
            // wave 13
            float waveArg13 = -(_Dir13.x * worldPos.x + _Dir13.y * worldPos.z) * FREQ(_omega13) + _Time * _phase;
            float wave_13_dir = _Amplitude13 * exp(sin(waveArg10)) * cos(waveArg13) * FREQ(_omega13);
            float wave_13_dx = -_Dir13.x * wave_13_dir;
            float wave_13_dz = -_Dir13.y * wave_13_dir;
            // wave 14
            float waveArg14 = -(_Dir14.x * worldPos.x + _Dir14.y * worldPos.z) * FREQ(_omega14) + _Time * _phase;
            float wave_14_dir = _Amplitude14 * exp(sin(waveArg14)) * cos(waveArg14) * FREQ(_omega14);
            float wave_14_dx = -_Dir14.x * wave_14_dir;
            float wave_14_dz = -_Dir14.y * wave_14_dir;
            // wave 15
            float waveArg15 = -(_Dir15.x * worldPos.x + _Dir15.y * worldPos.z) * FREQ(_omega15) + _Time * _phase;
            float wave_15_dir = _Amplitude15 * exp(sin(waveArg15)) * cos(waveArg15) * FREQ(_omega15);
            float wave_15_dx = -_Dir15.x * wave_15_dir;
            float wave_15_dz = -_Dir15.y * wave_15_dir;
            
            float total_dx = wave_1_dx + wave_2_dx + wave_3_dx + wave_4_dx + wave_5_dx + wave_6_dx + wave_7_dx
            + wave_8_dx + wave_9_dx + wave_10_dx + wave_11_dx + wave_12_dx + wave_13_dx + wave_14_dx + wave_15_dx;
            float total_dz = wave_1_dz + wave_2_dz + wave_3_dz + wave_4_dz + wave_5_dz + wave_6_dz + wave_7_dz
            + wave_8_dz + wave_9_dz + wave_10_dz + wave_11_dz + wave_12_dz + wave_13_dz + wave_14_dz + wave_15_dz;
            
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