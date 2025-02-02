Shader "ganmo_cake_timer"
{
	Properties 
	{
_MainTexture("_MainTexture", 2D) = "gray" {}
_MainColor("_MainColor", Color) = (1,1,1,1)
_HariTexture("_HariTexture", 2D) = "black" {}
_Density("_Density", Float) = 0

	}
	
	SubShader 
	{
		Tags
		{
"Queue"="Transparent"
"IgnoreProjector"="False"
"RenderType"="Transparent"

		}

		
Cull Back
ZWrite Off
ZTest LEqual
ColorMask RGBA
Blend SrcAlpha OneMinusSrcAlpha
Fog{
}


		CGPROGRAM
#pragma surface surf BlinnPhongEditor  vertex:vert
#pragma target 2.0


sampler2D _MainTexture;
float4 _MainColor;
sampler2D _HariTexture;
float4x4 _HariTextureMatrix;
float _Density;

			struct EditorSurfaceOutput {
				half3 Albedo;
				half3 Normal;
				half3 Emission;
				half3 Gloss;
				half Specular;
				half Alpha;
				half4 Custom;
			};
			
			inline half4 LightingBlinnPhongEditor_PrePass (EditorSurfaceOutput s, half4 light)
			{
half3 spec = light.a * s.Gloss;
half4 c;
c.rgb = (s.Albedo * light.rgb + light.rgb * spec);
c.a = s.Alpha;
return c;

			}

			inline half4 LightingBlinnPhongEditor (EditorSurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
			{
				half3 h = normalize (lightDir + viewDir);
				
				half diff = max (0, dot ( lightDir, s.Normal ));
				
				float nh = max (0, dot (s.Normal, h));
				float spec = pow (nh, s.Specular*128.0);
				
				half4 res;
				res.rgb = _LightColor0.rgb * diff;
				res.w = spec * Luminance (_LightColor0.rgb);
				res *= atten * 2.0;

				return LightingBlinnPhongEditor_PrePass( s, res );
			}
			
			struct Input {
				float2 uv_MainTexture;
float2 uv_HariTexture;

			};

			void vert (inout appdata_full v, out Input o) {
float4 VertexOutputMaster0_0_NoInput = float4(0,0,0,0);
float4 VertexOutputMaster0_1_NoInput = float4(0,0,0,0);
float4 VertexOutputMaster0_2_NoInput = float4(0,0,0,0);
float4 VertexOutputMaster0_3_NoInput = float4(0,0,0,0);


			}
			

			void surf (Input IN, inout EditorSurfaceOutput o) {
				o.Normal = float3(0.0,0.0,1.0);
				o.Alpha = 1.0;
				o.Albedo = 0.0;
				o.Emission = 0.0;
				o.Gloss = 0.0;
				o.Specular = 0.0;
				o.Custom = 0.0;
				
float4 Tex2D1=tex2D(_MainTexture,(IN.uv_MainTexture.xyxy).xy);
float4 Split0=(IN.uv_HariTexture.xyxy);
float4 Assemble0=float4(float4( Split0.x, Split0.x, Split0.x, Split0.x).x, float4( Split0.y, Split0.y, Split0.y, Split0.y).y, float4( 0.0, 0.0, 0.0, 0.0 ).z, float4( 1.0, 1.0, 1.0, 1.0 ).w);
float4 MxV0=mul( _HariTextureMatrix, Assemble0 );
float4 Tex2D0=tex2D(_HariTexture,MxV0.xy);
float4 Multiply1=Tex2D0.aaaa * _Density.xxxx;
float4 Invert0= float4(1.0, 1.0, 1.0, 1.0) - Multiply1;
float4 Multiply0=Tex2D1 * Invert0;
float4 Master0_0_NoInput = float4(0,0,0,0);
float4 Master0_1_NoInput = float4(0,0,1,1);
float4 Master0_3_NoInput = float4(0,0,0,0);
float4 Master0_4_NoInput = float4(0,0,0,0);
float4 Master0_7_NoInput = float4(0,0,0,0);
float4 Master0_6_NoInput = float4(1,1,1,1);
o.Emission = Multiply0;
o.Alpha = Tex2D1.aaaa;

				o.Normal = normalize(o.Normal);
			}
		ENDCG
	}
	Fallback "Diffuse"
}