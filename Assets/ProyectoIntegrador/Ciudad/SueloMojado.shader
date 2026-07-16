// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SueloMojado"
{
	Properties
	{
		_VelocidadAgua("VelocidadAgua", Vector) = (0,0.05,0,0)
		_VelocidadAgua1("VelocidadAgua", Vector) = (0.03,-0.03,0,0)
		_NormalMap("NormalMap", 2D) = "bump" {}
		_NormalMap1("NormalMap", 2D) = "bump" {}
		_Smoothness("Smoothness", Float) = 0.9
		_MezclaAgua("MezclaAgua", Float) = 0.5
		_ColorSuelo("ColorSuelo", Color) = (0.05,0.05,0.08,1)
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half filler;
		};

		uniform sampler2D _NormalMap;
		uniform float2 _VelocidadAgua;
		uniform sampler2D _NormalMap1;
		uniform float2 _VelocidadAgua1;
		uniform float _MezclaAgua;
		uniform float4 _ColorSuelo;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 panner2 = ( 1.0 * _Time.y * _VelocidadAgua + float2( 0,0 ));
			float2 panner8 = ( 1.0 * _Time.y * _VelocidadAgua1 + float2( 0,0 ));
			float4 lerpResult12 = lerp( tex2D( _NormalMap, panner2 ) , tex2D( _NormalMap1, panner8 ) , _MezclaAgua);
			o.Normal = lerpResult12.rgb;
			o.Albedo = _ColorSuelo.rgb;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;843;1989;508;1808.597;208.9094;1;True;False
Node;AmplifyShaderEditor.Vector2Node;3;-1517.77,-41.38943;Inherit;False;Property;_VelocidadAgua;VelocidadAgua;0;0;Create;True;0;0;0;False;0;False;0,0.05;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;7;-1527.096,124.0906;Inherit;False;Property;_VelocidadAgua1;VelocidadAgua;1;0;Create;True;0;0;0;False;0;False;0.03,-0.03;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;8;-1268.097,106.0906;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;4;-1238.771,-256.3894;Inherit;True;Property;_NormalMap;NormalMap;2;0;Create;True;0;0;0;False;0;False;31c6163b6243da04d8523e5aa3b6c810;31c6163b6243da04d8523e5aa3b6c810;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;2;-1258.771,-59.38942;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;9;-1279.597,258.424;Inherit;True;Property;_NormalMap1;NormalMap;3;0;Create;True;0;0;0;False;0;False;31c6163b6243da04d8523e5aa3b6c810;31c6163b6243da04d8523e5aa3b6c810;True;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;1;-945.7712,-91.38943;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-965.5972,123.424;Inherit;True;Property;_TextureSample1;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;13;-560.5972,165.0906;Inherit;False;Property;_MezclaAgua;MezclaAgua;5;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-193.5596,143.3021;Inherit;False;Property;_Smoothness;Smoothness;4;0;Create;True;0;0;0;False;0;False;0.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;12;-524.5972,19.09061;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;15;-338.5972,-128.9094;Inherit;False;Property;_ColorSuelo;ColorSuelo;6;0;Create;True;0;0;0;False;0;False;0.05,0.05,0.08,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SueloMojado;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;2;7;0
WireConnection;2;2;3;0
WireConnection;1;0;4;0
WireConnection;1;1;2;0
WireConnection;10;0;9;0
WireConnection;10;1;8;0
WireConnection;12;0;1;0
WireConnection;12;1;10;0
WireConnection;12;2;13;0
WireConnection;0;0;15;0
WireConnection;0;1;12;0
WireConnection;0;4;6;0
ASEEND*/
//CHKSM=85D380A1BB1ED6A80629CF0666302B81FDC95E45